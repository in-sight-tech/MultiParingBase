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
    bufferLength = 10;
  }

  @override
  void calSignal(ByteData bytes) async {
    StrainGaugeSignal signal = StrainGaugeSignal();

    biasTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - biasTime!;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3 * calValue;

    onData?.call(this, signal);
  }
}
