import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Imu extends SensorBase {
  String accelerationUnit = 'm/s²';

  ImuContents contents = ImuContents();

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
  void calSignal(ByteData bytes) async {
    ImuSignal signal = ImuSignal();

    biasTime ??= bytes.getInt32(2, Endian.little);
    signal.time = bytes.getInt32(2, Endian.little);

    if (contents.acceleration) {
      signal.ax = (bytes.getInt16(6, Endian.little) / 32768) * 16;
      signal.ay = (bytes.getInt16(8, Endian.little) / 32768) * 16;
      signal.az = (bytes.getInt16(10, Endian.little) / 32768) * 16;

      if (accelerationUnit == 'm/s²') {
        signal.ax = signal.ax! * 9.80665;
        signal.ay = signal.ay! * 9.80665;
        signal.az = signal.az! * 9.80665;
      }
    }

    if (contents.gyro) {
      signal.wx = (bytes.getInt16(2, Endian.little) / 32768) * 2000;
      signal.wy = (bytes.getInt16(4, Endian.little) / 32768) * 2000;
      signal.wz = (bytes.getInt16(6, Endian.little) / 32768) * 2000;
    }

    if (contents.angle) {
      signal.roll = (bytes.getInt16(2, Endian.little) / 32768) * 180;
      signal.pitch = (bytes.getInt16(4, Endian.little) / 32768) * 180;
      signal.yaw = (bytes.getInt16(6, Endian.little) / 32768) * 180;
    }

    onData?.call(this, signal);
  }

  void setReturnContent(ImuContents rc) {}

  void setBandwidth(int bandwidth) {}
}

class ImuContents {
  bool acceleration = true;
  bool gyro = false;
  bool angle = false;

  get config {
    int rsw = 0x01;

    if (acceleration) rsw |= 0x02;
    if (gyro) rsw |= 0x04;
    if (angle) rsw |= 0x08;

    return rsw;
  }

  List<String> units(String accUnit) {
    List<String> list = ['s'];

    if (acceleration && accUnit == 'm/s²') {
      list.addAll(['m/s^2', 'm/s^2', 'm/s^2']);
    } else if (acceleration && accUnit == 'g') {
      list.addAll(['g', 'g', 'g']);
    }

    if (gyro) list.addAll(['°/s', '°/s', '°/s']);
    if (angle) list.addAll(['°', '°', '°']);

    return list;
  }

  get names {
    List<String> list = ['time'];

    if (acceleration) list.addAll(['acc.x', 'acc.y', 'acc.z']);
    if (gyro) list.addAll(['wx', 'wy', 'wz']);
    if (angle) list.addAll(['roll', 'pitch', 'yaw']);

    return list;
  }
}
