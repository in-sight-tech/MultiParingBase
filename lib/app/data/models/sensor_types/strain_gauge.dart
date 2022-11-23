import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';

class StrainGauge extends SensorBase {
  @override
  Future<bool> connect() async {
    return false;
  }

  @override
  void disconnect() {}

  @override
  void start() {}
}
