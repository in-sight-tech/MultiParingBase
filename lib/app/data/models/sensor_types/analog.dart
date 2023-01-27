import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Analog extends SensorBase {
  num displacement1 = 0;
  num displacement2 = 0;
  num inputSignal1 = 0;
  num inputSignal2 = 0;
  bool mode = false;
  num calValue = 1.0;

  Analog({
    required BluetoothDevice device,
    Function(SensorBase)? dispose,
    Function(SensorBase, SignalBase)? onData,
  }) {
    super.device = device;
    super.dispose = dispose;
    super.onData = onData;
    bufferLength = 12;
  }

  @override
  void initConfig(json) {
    mode = json['mode'] == '5v' ? false : true;
    unit = json['unit'] as String;
    calValue = json['cal_value'];
    samplingRate = json['sampling_rate'] as int;
    displacement1 = json['displacement1'];
    displacement2 = json['displacement2'];
    inputSignal1 = json['input_signal1'];
    inputSignal2 = json['input_signal2'];
  }

  @override
  void calSignal(ByteData bytes) async {
    AnalogSignal signal = AnalogSignal();

    biasTime ??= bytes.getUint32(2, Endian.little);
    signal.time = bytes.getUint32(2, Endian.little) - biasTime!;

    signal.value = bytes.getFloat32(6, Endian.little);

    onData?.call(this, signal);
  }

  void setMode(String mode) {
    writeReg(data: '<sm$mode>');
  }

  void setDisplacement1(double value) {
    writeReg(data: '<dis1$value>');
  }

  void setDisplacement2(double value) {
    writeReg(data: '<dis2$value>');
  }

  void setImputSignal1(double value) {
    writeReg(data: '<is1$value>');
  }

  void setImputSignal2(double value) {
    writeReg(data: '<is2$value>');
  }
}
