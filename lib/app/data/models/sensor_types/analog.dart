import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
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
  int samplingRate = 200;
  double calValue = 0.0;

  Analog({
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
      connection = flutterReactiveBle.connectToDevice(id: device.id, connectionTimeout: const Duration(seconds: 4)).listen(
        (event) {
          if (event.connectionState == DeviceConnectionState.connected) {
            logger.i('connected');
          } else if (event.connectionState == DeviceConnectionState.disconnected) {
            logger.i('disconnected');
          }
        },
      );

      // stream = device.state.listen(listenState);

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
  void disconnect() => connection.cancel();

  @override
  void onInformation(Map<String, dynamic> information) {
    if (information['calibrationValue'] != null) {
      calValue = information['calibrationValue'];
    }
    if (information['unit'] != null) {
      unit = information['unit'];
    }
    if (information['samplingRate'] != null) {
      samplingRate = information['samplingRate'];
    }
  }

  @override
  void setSamplingRate(int samplingRate) => writeReg(data: '<sor$samplingRate>');

  @override
  void start() => writeReg(data: '<si${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');

  @override
  void stop() => writeReg(data: '<eoi>');

  void calibrate() => writeReg(data: '<zc>');

  void setCalibrationValue(double value) => writeReg(data: '<cv$value>');
}
