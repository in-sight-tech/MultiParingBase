import 'dart:typed_data';

class Sensor {
  BytesBuilder buffer = BytesBuilder();

  int frequency = 200;
  late int tick;
}
