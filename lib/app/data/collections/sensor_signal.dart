import 'package:isar/isar.dart';

part 'sensor_signal.g.dart';

@collection
class SensorSignal {
  Id id = Isar.autoIncrement;

  String sensorId;

  List<double?> signals;

  SensorSignal({required this.sensorId, required this.signals});

  @override
  String toString() {
    return 'Id: $sensorId\nSignals: $signals';
  }
}
