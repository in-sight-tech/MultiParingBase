import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart' as log;
import 'package:multiparingbase/app/data/models/signals/signal_base.dart';

abstract class SensorBase {
  late DiscoveredDevice device;
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  QualifiedCharacteristic? writeCharacteristic;
  QualifiedCharacteristic? readCharacteristic;
  QualifiedCharacteristic? notifyCharacteristic;
  late StreamSubscription<ConnectionStateUpdate> connection;

  Queue<int> buffer = Queue<int>();
  late int bufferLength;
  Map<String, dynamic> information = {};

  log.Logger logger = log.Logger();

  Future<bool> connect();
  void disconnect();
  void start();
  void stop();
  void calSignal(ByteData bytes);
  void setSamplingRate(int samplingRate);
  void onInformation(Map<String, dynamic> information);

  Function(SensorBase, SignalBase)? onData;
  Function(SensorBase)? dispose;

  Future<void> writeReg({required dynamic data, int delayMs = 0}) async {
    if (writeCharacteristic == null) return;
    flutterReactiveBle.writeCharacteristicWithoutResponse(writeCharacteristic!, value: const Utf8Encoder().convert("$data"));
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  bool isValiable(ByteData packets) {
    if (packets.lengthInBytes == 0) return false;
    int checksum = 0x00;

    for (int i = 0; i < packets.lengthInBytes - 2; i++) {
      checksum = (checksum + packets.getUint8(i)) & 0xffff;
    }

    return checksum == packets.getUint16(8, Endian.little);
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
              } else if (characteristic.isReadable) {
                readCharacteristic = QualifiedCharacteristic(
                  serviceId: service.serviceId,
                  characteristicId: characteristic.characteristicId,
                  deviceId: device.id,
                );
              }
            }
          }

          if (readCharacteristic != null) {
            flutterReactiveBle.readCharacteristic(readCharacteristic!).then((value) {
              information = jsonDecode(String.fromCharCodes(value));
              onInformation(information);
            });
          }

          if (notifyCharacteristic != null) {
            flutterReactiveBle.subscribeToCharacteristic(notifyCharacteristic!).listen((event) {
              for (int byte in event) {
                while (buffer.length >= bufferLength) {
                  if (buffer.elementAt(0) == 0x55 && buffer.elementAt(1) == 0x55) {
                    calSignal(ByteData.view(Uint8List.fromList(buffer.toList()).buffer));
                    buffer.clear();
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
