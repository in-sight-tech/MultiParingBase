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
}
