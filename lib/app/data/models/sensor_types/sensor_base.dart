import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:multiparingbase/app/data/models/signals/signal_base.dart';

abstract class SensorBase {
  late BluetoothDevice device;
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? readCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;
  Queue<int> buffer = Queue<int>();
  late int bufferLength;
  late StreamSubscription? stream;
  Map<String, dynamic> information = {};

  Logger logger = Logger();

  int samplingRate = 200;

  Future<bool> connect();
  void disconnect();
  void start();
  void stop();
  void calSignal(ByteData bytes);
  void setSamplingRate(int samplingRate);

  Function(SensorBase, SignalBase)? onData;
  Function(SensorBase)? dispose;

  Future<void> writeReg({required dynamic data, int delayMs = 0}) async {
    writeCharacteristic?.write(const Utf8Encoder().convert("$data"));
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

  void listenState(BluetoothDeviceState state) async {
    switch (state) {
      case BluetoothDeviceState.disconnected:
        logger.i('${device.name} disconnected');
        stream?.cancel();
        dispose?.call(this);
        break;
      case BluetoothDeviceState.connecting:
        logger.i('Connecting to ${device.name}...');
        break;
      case BluetoothDeviceState.connected:
        logger.i('${device.name} connected');

        for (BluetoothService service in await device.discoverServices()) {
          if (service.uuid != Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")) continue;
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.properties.notify == true) {
              notifyCharacteristic = characteristic;
            } else if (characteristic.properties.write == true) {
              writeCharacteristic = characteristic;
            } else if (characteristic.properties.read == true) {
              readCharacteristic = characteristic;
            }
          }
        }
        information = jsonDecode(String.fromCharCodes(await readCharacteristic?.read() ?? []));

        notifyCharacteristic?.setNotifyValue(true);
        stream = notifyCharacteristic?.value.listen((List<int> packets) {
          for (int byte in packets) {
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
        break;
      case BluetoothDeviceState.disconnecting:
        logger.i('Disconnecting from ${device.name}...');
        break;
    }
  }
}
