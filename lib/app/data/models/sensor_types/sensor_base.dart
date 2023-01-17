// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart' as log;
import 'package:multiparingbase/app/data/models/signals/signal_base.dart';
import 'package:intl/intl.dart';

abstract class SensorBase {
  static const CHARACTERISTIC_UUID_WRITE = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_NOTIFY = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_SAMPLINGRATE = "6E400004-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_CALVALUE = "6E400005-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_UNIT = "6E400006-B5A3-F393-E0A9-E50E24DCCA9E";
  static const CHARACTERISTIC_UUID_MODE = "6E400007-B5A3-F393-E0A9-E50E24DCCA9E";

  late DiscoveredDevice device;
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  QualifiedCharacteristic? writeCharacteristic;
  QualifiedCharacteristic? sampingRateCharacteristic;
  QualifiedCharacteristic? calValueCharacteristic;
  QualifiedCharacteristic? unitCharacteristic;
  QualifiedCharacteristic? modeCharacteristic;
  QualifiedCharacteristic? notifyCharacteristic;
  late StreamSubscription<ConnectionStateUpdate> connection;

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

  void disconnect() {
    try {
      connection.cancel();
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

  Future<void> writeReg({required String data, int delayMs = 0}) async {
    if (writeCharacteristic == null) return;
    flutterReactiveBle.writeCharacteristicWithoutResponse(writeCharacteristic!, value: const Utf8Encoder().convert(data));
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

  void listenState(ConnectionStateUpdate state) async {
    switch (state.connectionState) {
      case DeviceConnectionState.disconnected:
        logger.i('${device.name} disconnected');
        dispose?.call(this);
        break;
      case DeviceConnectionState.connecting:
        logger.i('Connecting to ${device.name}...');
        break;
      case DeviceConnectionState.connected:
        logger.i('${device.name} connected');

        flutterReactiveBle.discoverServices(device.id).then((services) {
          for (DiscoveredService service in services) {
            if (service.serviceId != Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")) continue;
            for (DiscoveredCharacteristic characteristic in service.characteristics) {
              if (characteristic.isNotifiable) {
                notifyCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              } else if (characteristic.isWritableWithResponse) {
                writeCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              } else if (characteristic.characteristicId == Uuid.parse(CHARACTERISTIC_UUID_SAMPLINGRATE)) {
                sampingRateCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              } else if (characteristic.characteristicId == Uuid.parse(CHARACTERISTIC_UUID_CALVALUE)) {
                calValueCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              } else if (characteristic.characteristicId == Uuid.parse(CHARACTERISTIC_UUID_UNIT)) {
                unitCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              } else if (characteristic.characteristicId == Uuid.parse(CHARACTERISTIC_UUID_MODE)) {
                modeCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              }
            }
          }

          if (sampingRateCharacteristic != null) {
            flutterReactiveBle.readCharacteristic(sampingRateCharacteristic!).then((value) {
              samplingRate = Uint8List.fromList(value.toList()).buffer.asByteData().getUint32(0, Endian.little);
            });
          }

          if (calValueCharacteristic != null) {
            flutterReactiveBle.readCharacteristic(calValueCharacteristic!).then((value) {
              calValue = Uint8List.fromList(value.toList()).buffer.asByteData().getFloat64(0, Endian.little);
            });
          }

          if (unitCharacteristic != null) {
            flutterReactiveBle.readCharacteristic(unitCharacteristic!).then((value) {
              unit = String.fromCharCodes(value);
            });
          }

          if (modeCharacteristic != null) {
            flutterReactiveBle.readCharacteristic(modeCharacteristic!).then((value) {
              mode = String.fromCharCodes(value) == '10v' ? true : false;
            });
          }

          if (notifyCharacteristic != null) {
            flutterReactiveBle.subscribeToCharacteristic(notifyCharacteristic!).listen((event) {
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
        });
        break;
      case DeviceConnectionState.disconnecting:
        logger.i('Disconnecting from ${device.name}...');
        break;
    }
  }
}
