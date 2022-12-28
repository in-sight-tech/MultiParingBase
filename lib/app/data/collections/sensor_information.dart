import 'package:isar/isar.dart';
import 'package:multiparingbase/app/data/enums.dart';

part 'sensor_information.g.dart';

@collection
class SensorInformation {
  Id id;

  @Enumerated(EnumType.ordinal)
  SensorType type;

  String deviceName;

  List<String> units;

  List<String> names;

  SensorInformation({required this.id, required this.deviceName, required this.type, required this.units, required this.names});

  @override
  String toString() {
    return 'Id: $id\nType: $type\nUnits: $units\nNames: $names';
  }
}
