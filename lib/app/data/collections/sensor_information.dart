import 'package:isar/isar.dart';
import 'package:multiparingbase/app/data/enums.dart';

part 'sensor_information.g.dart';

@collection
class SensorInformation {
  String id;

  Id get isarId => fastHash(id);

  @Enumerated(EnumType.ordinal)
  SensorType type;

  List<String> units;

  List<String> names;

  SensorInformation({required this.id, required this.type, required this.units, required this.names});

  static int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  @override
  String toString() {
    return 'Id: $id\nType: $type\nUnits: $units\nNames: $names';
  }
}
