import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Analog extends SensorBase {
  void Function()? onResponse;
  void Function()? onError;

  int? predictTime;
  int? biasTime;

  int? preByte;

  String unit = 'mm';

  Analog({
    required BluetoothDevice device,
    Function(SensorBase)? dispose,
    Function(SensorBase, SignalBase)? onData,
  }) {
    super.device = device;
    super.dispose = dispose;
    super.onData = onData;

    bufferLength = 10;
  }

  @override
  Future<bool> connect() async {
    try {
      await device.connect(autoConnect: false);

      stream = device.state.listen(listenState);

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  void calSignal(ByteData bytes) async {
    AnalogSignal signal = AnalogSignal();

    biasTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - biasTime!;
    predictTime ??= signal.time!;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3;

    onData?.call(this, signal);
  }

  @override
  void disconnect() => device.disconnect();

  @override
  void setSamplingRate(int samplingRate) => writeReg(data: '<sor$samplingRate>');

  @override
  void start() => writeReg(data: '<si${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');

  @override
  void stop() => writeReg(data: '<eoi>');

  void calibrate() => writeReg(data: '<zc>');

  void setCalibrationValue(double value) => writeReg(data: '<cv$value>');
}
