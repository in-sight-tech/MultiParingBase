import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:multiparingbase/app/data/models/sensor.dart';

class IMU extends Sensor {
  Function(IMU, List<double?>)? onData;
  Function(IMU)? disConnect;

  Timer? _timer;

  int? opCode;
  int? predictTime;
  int? biasTime;

  String accelerationUnit = 'm/s²';

  ReturnContents returnContents = ReturnContents();

  List<String> names = ['time', 'acc.x', 'acc.y', 'acc.z'];
  List<String> units = ['s', 'm/s^2', 'm/s^2', 'm/s^2'];
  List<double?> signals = [null, null, null, null];

  IMU({
    required device,
    this.onData,
    this.disConnect,
  }) {
    super.device = device;

    tick = 1000 ~/ frequency;
  }

  @override
  void dispose() {
    connection?.dispose();
    _timer?.cancel();
  }

  @override
  Future<bool> connect() async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);

      if (connection?.isConnected == false) throw 'Connect error';

      await setReturnRate(frequency);
      await setReturnContent(returnContents);

      connection?.input?.listen((Uint8List packets) {
        for (int byte in packets) {
          if (byte != 0x55) {
            buffer.addByte(byte);
            continue;
          }

          if (buffer.length != 11) {
            buffer.clear();
            buffer.addByte(byte);
            continue;
          }

          if (!isValiable(buffer.toBytes())) {
            buffer.clear();
            continue;
          }

          calSignal(buffer.takeBytes().buffer.asByteData());
          buffer.clear();

          buffer.addByte(byte);
        }
      }).onDone(() {
        disConnect?.call(this);
      });

      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        try {
          connection?.output.add(Uint8List.fromList([0x01]));
        } catch (e) {
          if (kDebugMode) print(e);
        }
      });

      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  void calSignal(ByteData bytes) async {
    if (opCode == null) {
      signals = [null];

      if (returnContents.acceleration) {
        signals.addAll([null, null, null]);
      }
      if (returnContents.angularVelocity) {
        signals.addAll([null, null, null]);
      }
      if (returnContents.angle) {
        signals.addAll([null, null, null]);
      }
    } else if (opCode! > bytes.getInt8(1)) {
      signals[0] ??= predictTime!.toDouble();

      if (signals[0] == predictTime) {
        onData?.call(this, signals);
        predictTime = predictTime! + tick;
      } else {
        while (predictTime! < signals[0]!) {
          signals[0] = predictTime!.toDouble();
          onData?.call(this, signals);
          predictTime = predictTime! + tick;
        }

        onData?.call(this, signals);
        predictTime = predictTime! + tick;
      }

      signals = [null];

      if (returnContents.acceleration) {
        signals.addAll([null, null, null]);
      }
      if (returnContents.angularVelocity) {
        signals.addAll([null, null, null]);
      }
      if (returnContents.angle) {
        signals.addAll([null, null, null]);
      }
    }

    switch (bytes.getInt8(1)) {
      case 0x50:
        opCode = 0x50;
        biasTime ??= bytes.getInt8(5) * 60 * 60 * 1000 + bytes.getInt8(6) * 60 * 1000 + bytes.getInt8(7) * 1000 + bytes.getInt16(8, Endian.little);
        signals[0] = (bytes.getInt8(5) * 60 * 60 * 1000 + bytes.getInt8(6) * 60 * 1000 + bytes.getInt8(7) * 1000 + bytes.getInt16(8, Endian.little) - biasTime!).toDouble();
        predictTime ??= signals[0]!.toInt() + tick;
        break;
      case 0x51:
        if (opCode == null) return;
        opCode = 0x51;

        int index = names.indexOf('acc.x');
        if (index == -1) return;

        signals[index] = (bytes.getInt16(2, Endian.little) / 32768) * 16;
        signals[index + 1] = (bytes.getInt16(4, Endian.little) / 32768) * 16;
        signals[index + 2] = (bytes.getInt16(6, Endian.little) / 32768) * 16;

        if (accelerationUnit == 'm/s²') {
          signals[index] = signals[index]! * 9.80665;
          signals[index + 1] = signals[index + 1]! * 9.80665;
          signals[index + 2] = signals[index + 2]! * 9.80665;
        }
        break;
      case 0x52:
        if (opCode == null) return;
        opCode = 0x52;

        int index = names.indexOf('w.x');
        if (index == -1) return;

        signals[index] = (bytes.getInt16(2, Endian.little) / 32768) * 2000;
        signals[index + 1] = (bytes.getInt16(4, Endian.little) / 32768) * 2000;
        signals[index + 2] = (bytes.getInt16(6, Endian.little) / 32768) * 2000;
        break;
      case 0x53:
        if (opCode == null) return;
        opCode = 0x53;

        int index = names.indexOf('roll');
        if (index == -1) return;

        signals[index] = (bytes.getInt16(2, Endian.little) / 32768) * 180;
        signals[index + 1] = (bytes.getInt16(4, Endian.little) / 32768) * 180;
        signals[index + 2] = (bytes.getInt16(6, Endian.little) / 32768) * 180;
        break;
    }
  }

  Future<bool> setUnit(String unit) async {
    accelerationUnit = unit;

    return true;
  }

  Future<bool> calibrate() async {
    await writeReg(addr: 0x69, data: 0xb588, delayMs: 50);
    await writeReg(addr: 0x01, data: 0x0001, delayMs: 3050);
    await writeReg(addr: 0x01, data: 0x0000, delayMs: 3100);
    await writeReg(addr: 0x00, data: 0x0000);

    return true;
  }

  Future<bool> setReturnRate(int frequency) async {
    Map<int, int> frequencyCode = {
      1: 0x03,
      2: 0x04,
      5: 0x05,
      10: 0x06,
      20: 0x07,
      50: 0x08,
      100: 0x09,
      125: 0x0a,
      200: 0x0b,
    };

    opCode = null;
    predictTime = null;

    this.frequency = frequency;
    tick = 1000 ~/ frequency;

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x03, data: frequencyCode[frequency], delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000);

    return true;
  }

  Future<bool> setReturnContent(ReturnContents rc) async {
    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x02, data: rc.config, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x02, data: rc.config, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000);

    returnContents = rc;

    names = ['time'];
    units = ['s'];

    if (returnContents.acceleration) {
      names.addAll(['acc.x', 'acc.y', 'acc.z']);
      units.addAll(['m/s^2', 'm/s^2', 'm/s^2']);
    }
    if (returnContents.angularVelocity) {
      names.addAll(['w.x', 'w.y', 'w.z']);
      units.addAll(['°/s', '°/s', '°/s']);
    }
    if (returnContents.angle) {
      names.addAll(['roll', 'pitch', 'yaw']);
      units.addAll(['°', '°', '°']);
    }

    return true;
  }

  Future<bool> setBandwidth(int bandwidth) async {
    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x1F, data: bandwidth, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000);

    return true;
  }

  Future<void> writeReg({required int addr, required dynamic data, int delayMs = 0}) async {
    connection?.output.add(Uint8List.fromList([0xFF, 0xAA, addr, data & 0xff, (data >> 8) & 0xff]));
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  bool isValiable(Uint8List packets) {
    int checksum = 0x00;

    for (int i = 0; i < packets.length - 1; i++) {
      checksum = (checksum + packets[i]) & 0xff;
    }

    return checksum == packets.last;
  }

  @override
  void start() {
    biasTime = null;
    opCode = null;
    predictTime = null;
  }
}

class ReturnContents {
  bool acceleration = true;
  bool angularVelocity = false;
  bool angle = false;

  get config {
    int rsw = 0x01;

    if (acceleration) rsw |= 0x02;
    if (angularVelocity) rsw |= 0x04;
    if (angle) rsw |= 0x08;

    return rsw;
  }
}
