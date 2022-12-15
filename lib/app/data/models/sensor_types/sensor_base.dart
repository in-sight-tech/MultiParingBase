import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class SensorBase {
  late BluetoothDevice device;
  BluetoothConnection? connection;

  List<int> buffer = [];

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
