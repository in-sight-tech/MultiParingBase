import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals/imu_signal.dart';

class Imu extends SensorBase {
  late ImuSignal signal;

  Future<void> Function(Imu, ImuSignal)? onData;
  Function(Imu)? dispose;

  int? opCode;
  int? biasTime;

  String accelerationUnit = 'm/s²';

  ImuReturnContents returnContents = ImuReturnContents();

  int bufferLength = 0;

  Imu({
    required BluetoothDevice device,
    this.onData,
    this.dispose,
  }) {
    super.device = device;
    tick = 1000 ~/ samplingRate;
  }

  @override
  void disconnect() {
    device.disconnect();
  }

  @override
  Future<bool> connect() async {
    try {
      Logger().i('Connecting to ${device.name}...');

      await device.connect(autoConnect: false);

      device.state.listen((BluetoothDeviceState state) {
        if (state == BluetoothDeviceState.disconnected) {
          dispose?.call(this);
        }
      });

      services = await device.discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.properties.notify == true) {
            characteristic.setNotifyValue(true);
            characteristic.value.listen((List<int> packets) {
              for (int byte in packets) {
                while (buffer.length > 12) {
                  if (buffer.elementAt(0) == 0x55 && buffer.elementAt(1) == 0x55) {
                    calSignal(ByteData.view(Uint8List.fromList(buffer.toList()).buffer));
                    buffer.clear();
                  } else {
                    buffer.removeFirst();
                  }
                }
                buffer.add(byte);
              }
            });
          }
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  void calSignal(ByteData bytes) async {
    signal = ImuSignal();

    biasTime ??= bytes.getInt32(2, Endian.little);
    signal.time = bytes.getInt32(2, Endian.little);

    signal.ax = (bytes.getInt16(6, Endian.little) / 32768) * 16;
    signal.ay = (bytes.getInt16(8, Endian.little) / 32768) * 16;
    signal.az = (bytes.getInt16(10, Endian.little) / 32768) * 16;

    if (accelerationUnit == 'm/s²') {
      signal.ax = signal.ax! * 9.80665;
      signal.ay = signal.ay! * 9.80665;
      signal.az = signal.az! * 9.80665;
    }

    // signal.wx = (bytes.getInt16(2, Endian.little) / 32768) * 2000;
    // signal.wy = (bytes.getInt16(4, Endian.little) / 32768) * 2000;
    // signal.wz = (bytes.getInt16(6, Endian.little) / 32768) * 2000;

    // signal.roll = (bytes.getInt16(2, Endian.little) / 32768) * 180;
    // signal.pitch = (bytes.getInt16(4, Endian.little) / 32768) * 180;
    // signal.yaw = (bytes.getInt16(6, Endian.little) / 32768) * 180;

    onData?.call(this, signal);
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

    return true;
  }

  @override
  Future<bool> setSamplingRate(int samplingRate) async {
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

    samplingRate = samplingRate;
    tick = 1000 ~/ samplingRate;

    await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    await writeReg(addr: 0x03, data: frequencyCode[samplingRate], delayMs: 100);
    await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    return true;
  }

  Future<bool> setReturnContent(ImuReturnContents rc) async {
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

    return true;
  }

  Future<void> writeReg({required dynamic addr, required dynamic data, int delayMs = 0}) async {
    // connection?.output.add(Uint8List.fromList([0xFF, 0xAA, addr, data & 0xff, (data >> 8) & 0xff]));
    // await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  void start() {
    biasTime = null;
    opCode = null;
  }

  @override
  void stop() {
    biasTime = null;
    opCode = null;
  }
}

class ImuReturnContents {
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
