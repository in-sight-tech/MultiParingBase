import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGauge extends SensorBase {
  StrainGauge({
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
    StrainGaugeSignal signal = StrainGaugeSignal();

    biasTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(2, Endian.little) - biasTime!;

    signal.value = bytes.getFloat32(6, Endian.little).toDouble();

    onData?.call(this, signal);
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
