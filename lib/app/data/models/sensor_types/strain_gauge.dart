import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGauge extends SensorBase {
  int? startTime;

  int? preByte;

  String unit = 'mm';

  StrainGauge({
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
      await device.connect(timeout: const Duration(seconds: 4), autoConnect: false);

      stream = device.state.listen(listenState);

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  void calSignal(ByteData bytes) async {
    StrainGaugeSignal signal = StrainGaugeSignal();

    if (isValiable(bytes) == false) return;

    startTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - startTime!;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3;

    onData?.call(this, signal);
  }

  @override
  void disconnect() => device.disconnect();

  void setUnit(String unit) {
    this.unit = unit;
    writeReg(data: '<su$unit>');
  }

  @override
  void setSamplingRate(int samplingRate) => writeReg(data: '<sor$samplingRate>');

  @override
  void start() {
    startTime = null;
    writeReg(data: '<si${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');
  }

  @override
  void stop() => writeReg(data: '<eoi>');

  void calibrate() => writeReg(data: '<zc>');

  void setName(String name) => writeReg(data: '<sn$name>');
  
  void setCalibrationValue(double value) => writeReg(data: '<cv$value>');
}
