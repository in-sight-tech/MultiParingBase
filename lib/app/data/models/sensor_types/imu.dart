import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Imu extends SensorBase {
  late ImuSignal signal;

  int? opCode;
  int? biasTime;

  String accelerationUnit = 'm/s²';
  int samplingRate = 200;

  ImuReturnContents returnContents = ImuReturnContents();

  Imu({
    required DiscoveredDevice device,
    Function(SensorBase)? dispose,
    Function(SensorBase, SignalBase)? onData,
  }) {
    super.device = device;
    super.dispose = dispose;
    super.onData = onData;

    bufferLength = 12;
  }

  @override
  void disconnect() => connection.cancel();

  @override
  Future<bool> connect() async {
    try {
      connection = flutterReactiveBle.connectToDevice(id: device.id, connectionTimeout: const Duration(seconds: 4)).listen(
        (event) {
          if (event.connectionState == DeviceConnectionState.connected) {
            logger.i('connected');
          } else if (event.connectionState == DeviceConnectionState.disconnected) {
            logger.i('disconnected');
          }
        },
      );

      // device.state.listen(listenState);

      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  @override
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

  @override
  void onInformation(Map<String, dynamic> information) {
    if (information['unit'] != null) {
      accelerationUnit = information['unit'];
    }
    if (information['samplingRate'] != null) {
      samplingRate = information['samplingRate'];
    }
  }

  Future<bool> setUnit(String unit) async {
    accelerationUnit = unit;

    return true;
  }

  Future<bool> calibrate() async {
    // await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    // await writeReg(addr: 0x01, data: 0x0001, delayMs: 3000);
    // await writeReg(addr: 0x01, data: 0x0000, delayMs: 100);
    // await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

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

    // await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    // await writeReg(addr: 0x03, data: frequencyCode[samplingRate], delayMs: 100);
    // await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    return true;
  }

  Future<bool> setReturnContent(ImuReturnContents rc) async {
    // await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    // await writeReg(addr: 0x02, data: rc.config, delayMs: 100);
    // await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    returnContents = rc;

    return true;
  }

  Future<bool> setBandwidth(int bandwidth) async {
    // await writeReg(addr: 0x69, data: 0xb588, delayMs: 100);
    // await writeReg(addr: 0x1F, data: bandwidth, delayMs: 100);
    // await writeReg(addr: 0x00, data: 0x0000, delayMs: 100);

    return true;
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
