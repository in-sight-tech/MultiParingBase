import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals/bwt901cl_signal.dart';

class BWT901CL extends SensorBase {
  late BWT901CLSignal signal;

  Function(BWT901CL, BWT901CLSignal)? onData;
  Function(BWT901CL)? dispose;

  Timer? _timer;

  int? opCode;
  int? predictTime;
  int? biasTime;

  String accelerationUnit = 'm/s²';

  ReturnContents returnContents = ReturnContents();

  BWT901CL({
    required BluetoothDevice device,
    this.onData,
    this.dispose,
  }) {
    super.device = device;
    tick = 1000 ~/ frequency;
  }

  @override
  void disconnect() {
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
        dispose?.call(this);
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
      signal = BWT901CLSignal();
    } else if (opCode! > bytes.getInt8(1)) {
      signal.time ??= predictTime;
      if (signal.time == predictTime) {
        onData?.call(this, signal);
        predictTime = predictTime! + tick;
      } else {
        while (predictTime! < signal.time!) {
          onData?.call(this, BWT901CLSignal(time: predictTime));
          predictTime = predictTime! + tick;
        }

        onData?.call(this, signal);
        predictTime = predictTime! + tick;
      }

      signal = BWT901CLSignal();
    }

    switch (bytes.getInt8(1)) {
      case 0x50:
        opCode = 0x50;
        biasTime ??= bytes.getInt8(5) * 60 * 60 * 1000 + bytes.getInt8(6) * 60 * 1000 + bytes.getInt8(7) * 1000 + bytes.getInt16(8, Endian.little);
        signal.time = bytes.getInt8(5) * 60 * 60 * 1000 + bytes.getInt8(6) * 60 * 1000 + bytes.getInt8(7) * 1000 + bytes.getInt16(8, Endian.little) - biasTime!;
        predictTime ??= signal.time! + tick;
        break;
      case 0x51:
        if (opCode == null) return;
        opCode = 0x51;

        signal.ax = (bytes.getInt16(2, Endian.little) / 32768) * 16;
        signal.ay = (bytes.getInt16(4, Endian.little) / 32768) * 16;
        signal.az = (bytes.getInt16(6, Endian.little) / 32768) * 16;

        if (accelerationUnit == 'm/s²') {
          signal.ax = signal.ax! * 9.80665;
          signal.ay = signal.ay! * 9.80665;
          signal.az = signal.az! * 9.80665;
        }
        break;
      case 0x52:
        if (opCode == null) return;
        opCode = 0x52;

        signal.wx = (bytes.getInt16(2, Endian.little) / 32768) * 2000;
        signal.wy = (bytes.getInt16(4, Endian.little) / 32768) * 2000;
        signal.wz = (bytes.getInt16(6, Endian.little) / 32768) * 2000;
        break;
      case 0x53:
        if (opCode == null) return;
        opCode = 0x53;

        signal.roll = (bytes.getInt16(2, Endian.little) / 32768) * 180;
        signal.pitch = (bytes.getInt16(4, Endian.little) / 32768) * 180;
        signal.yaw = (bytes.getInt16(6, Endian.little) / 32768) * 180;
        break;
    }
  }

  Future<bool> setUnit(String unit) async {
    accelerationUnit = unit;

    return true;
  }

  Future<bool> calibrate() async {
    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x01, data: 0x0001, delayMs: 3000);
    await writeReg(addr: 0x01, data: 0x0000, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x01, data: 0x0001, delayMs: 3000);
    await writeReg(addr: 0x01, data: 0x0000, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    return true;
  }

  @override
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
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x03, data: frequencyCode[frequency], delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    return true;
  }

  Future<bool> setReturnContent(ReturnContents rc) async {
    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x02, data: rc.config, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x02, data: rc.config, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    returnContents = rc;

    return true;
  }

  Future<bool> setBandwidth(int bandwidth) async {
    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x1F, data: bandwidth, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x1F, data: bandwidth, delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    return true;
  }

  @override
  Future<void> writeReg({required int addr, required dynamic data, int delayMs = 0}) async {
    connection?.output.add(Uint8List.fromList([0xFF, 0xAA, addr, data & 0xff, (data >> 8) & 0xff]));
    await Future.delayed(Duration(milliseconds: delayMs));
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

  List<String> toUnitList(String accUnit) {
    List<String> list = ['s'];

    if (acceleration && accUnit == 'm/s²') {
      list.addAll(['m/s^2', 'm/s^2', 'm/s^2']);
    } else if (acceleration && accUnit == 'g') {
      list.addAll(['g', 'g', 'g']);
    }

    if (angularVelocity) list.addAll(['°/s', '°/s', '°/s']);
    if (angle) list.addAll(['°', '°', '°']);

    return list;
  }

  List<String> toNameList() {
    List<String> list = ['time'];

    if (acceleration) list.addAll(['acc.x', 'acc.y', 'acc.z']);
    if (angularVelocity) list.addAll(['wx', 'wy', 'wz']);
    if (angle) list.addAll(['roll', 'pitch', 'yaw']);

    return list;
  }
}
