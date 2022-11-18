import 'package:multiparingbase/app/data/models/sensor.dart';

class StrainGauge extends Sensor {
  @override
  Future<bool> connect() async {
    return false;
  }

  @override
  void dispose() {}

  @override
  void start() {}
}
