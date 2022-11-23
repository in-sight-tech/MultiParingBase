import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class SensorBase {
  late BluetoothDevice device;
  BluetoothConnection? connection;

  BytesBuilder buffer = BytesBuilder();

  int frequency = 200;
  late int tick;

  Future<bool> connect();
  void start();
  void disconnect();
  Future<bool> setReturnRate(int frequency);

  bool isValiable(Uint8List packets) {
    int checksum = 0x00;

    for (int i = 0; i < packets.length - 1; i++) {
      checksum = (checksum + packets[i]) & 0xff;
    }

    return checksum == packets.last;
  }
}
