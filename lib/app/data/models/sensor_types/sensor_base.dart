// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart' as log;
import 'package:multiparingbase/app/data/models/signals/signal_base.dart';
import 'package:intl/intl.dart';

abstract class SensorBase {
  static const CHARACTERISTIC_UUID_WRITE = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_NOTIFY = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_CONFIG = "6E400004-B5A3-F393-E0A9-E50E24DCCA9E";

  late BluetoothDevice device;
  BluetoothService? service;
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;
  BluetoothCharacteristic? configCharacteristic;

  Queue<int> buffer = Queue<int>();
  late int bufferLength;

  log.Logger logger = log.Logger();

  Function(SensorBase, SignalBase)? onData;
  Function(SensorBase)? dispose;

  String unit = 'v';
  int samplingRate = 200;
  double calValue = 1.0;
  bool mode = false;
  int? biasTime;
  int? rsw;

  Future<bool> connect() async {
    try {
      await device.connect(autoConnect: false);

      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid == Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")) {
          this.service = service;
        }
      }

      if (service == null) {
        return false;
      }

      List<BluetoothCharacteristic> characteristics = service!.characteristics;
      for (var characteristic in characteristics) {
        if (characteristic.uuid == Guid(CHARACTERISTIC_UUID_WRITE)) {
          writeCharacteristic = characteristic;
        } else if (characteristic.uuid == Guid(CHARACTERISTIC_UUID_NOTIFY)) {
          notifyCharacteristic = characteristic;
        } else if (characteristic.uuid == Guid(CHARACTERISTIC_UUID_CONFIG)) {
          configCharacteristic = characteristic;
        }
      }

      connectCharacteristic();

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  void disconnect() {
    try {
      device.disconnect();
      dispose?.call(this);
    } catch (e) {
      logger.e(e);
    }
  }

  void start() {
    biasTime = null;
    writeReg(data: '<si${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');
  }

  void stop() => writeReg(data: '<eoi>');

  void calSignal(ByteData bytes);

  void setSamplingRate(int samplingRate) => writeReg(data: '<sor$samplingRate>');

  void setName(String name) => writeReg(data: '<sn$name>');

  void calibrate() => writeReg(data: '<zc>');

  void setCalibrationValue(double value) => writeReg(data: '<cv$value>');

  void setUnit(String unit) => writeReg(data: '<su$unit>');

  void requestConfig() => writeReg(data: '<rc>');

  Future<void> writeReg({required String data, int delayMs = 0}) async {
    if (writeCharacteristic == null) return;
    writeCharacteristic?.write(data.codeUnits);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  bool isValiable(ByteData packets) {
    if (packets.lengthInBytes == 0) return false;
    int checksum = 0x00;

    for (int i = 0; i < packets.lengthInBytes - 2; i++) {
      checksum = (checksum + packets.getUint8(i)) & 0xffff;
    }

    return checksum == packets.getUint16(bufferLength - 2, Endian.little);
  }

  connectCharacteristic() {
    if (configCharacteristic != null) {
      configCharacteristic!.setNotifyValue(true);
      configCharacteristic!.value.listen((event) {
        print(String.fromCharCodes(event));
      });

      Future.delayed(const Duration(seconds: 1)).then((value) => requestConfig());
    }

    if (notifyCharacteristic != null) {
      notifyCharacteristic!.setNotifyValue(true);
      notifyCharacteristic!.value.listen((event) {
        for (int byte in event) {
          while (buffer.length >= bufferLength) {
            if (buffer.elementAt(0) == 0x55 && buffer.elementAt(1) == 0x55) {
              if (isValiable(ByteData.view(Uint8List.fromList(buffer.toList()).buffer))) {
                calSignal(ByteData.view(Uint8List.fromList(buffer.toList()).buffer));
                buffer.clear();
              } else {
                buffer.removeFirst();
              }
            } else {
              buffer.removeFirst();
            }
          }
          buffer.add(byte);
        }
      });
    }
  }
}
