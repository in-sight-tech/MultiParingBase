import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class SensorBase {
  late BluetoothDevice device;
  late List<BluetoothService> services;
  List<BluetoothCharacteristic>? characteristics;

  Queue<int> buffer = Queue<int>();

  int samplingRate = 200;
  late int tick;

  Future<bool> connect();
  void start();
  void stop();
  void disconnect();
  dynamic setSamplingRate(int samplingRate);

  bool isValiable(Uint8List packets) {
    if (packets.isEmpty) return false;
    int checksum = 0x00;

    for (int i = 0; i < packets.length - 1; i++) {
      checksum = (checksum + packets[i]) & 0xff;
    }

    return checksum == packets.last;
  }
}

enum Mode { command, normal, fileTransfer }
