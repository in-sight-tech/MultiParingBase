import 'package:multiparingbase/app/data/models/sensor.dart';

class StrainGauge extends Sensor {
  @override
  connect() {
    return false;
  }
}
