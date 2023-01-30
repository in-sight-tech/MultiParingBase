import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Imu extends SensorBase {
  ImuContents? contents;

  Imu({
    required BluetoothDevice device,
    Function(SensorBase)? dispose,
    Function(SensorBase, SignalBase)? onData,
  }) {
    super.device = device;
    super.dispose = dispose;
    super.onData = onData;
  }

  @override
  void initConfig(json) {
    samplingRate = json['sampling_rate'] as int;
    unit = json['unit'] as String;
    contents = ImuContents(json['rsw'] as int);
    bufferLength = 8 + contents!.getNumberOfActiveContent * 6;
  }

  @override
  void calSignal(ByteData bytes) async {
    ImuSignal signal = ImuSignal();
    int index = 6;

    biasTime ??= bytes.getInt32(2, Endian.little);
    signal.time = bytes.getInt32(2, Endian.little);

    if (contents?.acceleration ?? false) {
      signal.ax = (bytes.getInt16(index, Endian.little) / 32768) * 16;
      signal.ay = (bytes.getInt16(index + 2, Endian.little) / 32768) * 16;
      signal.az = (bytes.getInt16(index + 4, Endian.little) / 32768) * 16;

      if (unit == 'm/s²') {
        signal.ax = signal.ax! * 9.80665;
        signal.ay = signal.ay! * 9.80665;
        signal.az = signal.az! * 9.80665;
      }

      index += 6;
    }

    if (contents?.gyro ?? false) {
      signal.wx = (bytes.getInt16(index, Endian.little) / 32768) * 2000;
      signal.wy = (bytes.getInt16(index + 2, Endian.little) / 32768) * 2000;
      signal.wz = (bytes.getInt16(index + 4, Endian.little) / 32768) * 2000;

      index += 6;
    }

    if (contents?.angle ?? false) {
      signal.roll = (bytes.getInt16(index, Endian.little) / 32768) * 180;
      signal.pitch = (bytes.getInt16(index + 2, Endian.little) / 32768) * 180;
      signal.yaw = (bytes.getInt16(index + 4, Endian.little) / 32768) * 180;
    }

    onData?.call(this, signal);
  }

  void setReturnContent(ImuContents rc) {
    writeReg(data: '<src${rc.config}>');

    bufferLength = 8 + rc.getNumberOfActiveContent * 6;
  }
}

class ImuContents {
  bool acceleration = true;
  bool gyro = false;
  bool angle = false;

  ImuContents(int rsw) {
    acceleration = (rsw & 0x02) == 0x02;
    gyro = (rsw & 0x04) == 0x04;
    angle = (rsw & 0x08) == 0x08;
  }

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

  int get getNumberOfActiveContent {
    int count = 0;

    if (acceleration) count++;
    if (gyro) count++;
    if (angle) count++;

    return count;
  }
}
