import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Analog extends SensorBase {
  Analog({
    required DiscoveredDevice device,
    Function(SensorBase)? dispose,
    Function(SensorBase, SignalBase)? onData,
  }) : super(
          device: device,
          dispose: dispose,
          onData: onData,
        ) {
    bufferLength = 10;
  }

  @override
  void calSignal(ByteData bytes) async {
    AnalogSignal signal = AnalogSignal();

    biasTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - biasTime!;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3;

    onData?.call(this, signal);
  }

  void setMode(String mode) {
    writeReg(data: '<sm$mode>');
  }
}
