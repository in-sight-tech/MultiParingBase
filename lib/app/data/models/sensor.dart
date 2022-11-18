import 'dart:typed_data';

abstract class Sensor {
  BytesBuilder buffer = BytesBuilder();

  int frequency = 200;
  late int tick;

  Future<bool> connect();
  void start();
  void dispose();
}
