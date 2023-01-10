import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:intl/intl.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGauge extends SensorBase {
  int? startTime;

  int? preByte;

  String unit = 'mm';
  int samplingRate = 200;
  double calValue = 0.0;

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
  Future<bool> connect() async {
    try {
      connection = flutterReactiveBle
          .connectToDevice(
            id: device.id,
            connectionTimeout: const Duration(seconds: 4),
          )
          .listen(listenState);

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  void calSignal(ByteData bytes) async {
    StrainGaugeSignal signal = StrainGaugeSignal();

    startTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - startTime!;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3 * calValue;

    onData?.call(this, signal);
  }

  @override
  void disconnect() {
    connection.cancel();
    super.dispose?.call(this);
  }

  @override
  void onInformation(Map<String, dynamic> information) {
    logger.i(information);
    calValue = double.tryParse(information['calValue'].toString()) ?? 1.0;
    unit = information['unit'] ?? 'mm';
    samplingRate = information['sampling_rate'] ?? 100;
  }

  void setUnit(String unit) {
    this.unit = unit;
    writeReg(data: '<su$unit>');
  }

  @override
  void setSamplingRate(int samplingRate) {
    this.samplingRate = samplingRate;
    writeReg(data: '<sor$samplingRate>');
  }

  @override
  void start() {
    startTime = null;
    writeReg(data: '<si${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');
  }

  @override
  void stop() => writeReg(data: '<eoi>');

  void calibrate() => writeReg(data: '<zc>');

  void setName(String name) => writeReg(data: '<sn$name>');

  void setCalibrationValue(double value) {
    calValue = value;
    writeReg(data: '<cv$value>');
  }
}
