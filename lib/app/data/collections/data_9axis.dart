import 'package:isar/isar.dart';

part 'data_9axis.g.dart';

@collection
class SensorSignal {
  Id id = Isar.autoIncrement;

  int? time;

  double? ax;

  double? ay;

  double? az;

  double? wx;

  double? wy;

  double? wz;

  double? roll;

  double? pitch;

  double? yaw;

  SensorSignal({this.time});

  @override
  String toString() {
    return '$time, $ax, $ay, $az, $wx, $wy, $wz, $roll, $pitch, $yaw';
  }

  factory SensorSignal.copyWith(SensorSignal copy) => SensorSignal()
    ..time = copy.time
    ..ax = copy.ax
    ..ay = copy.ay
    ..az = copy.az
    ..wx = copy.wx
    ..wy = copy.wy
    ..wz = copy.wz
    ..roll = copy.roll
    ..pitch = copy.pitch
    ..yaw = copy.yaw;

  List<double?> toList() {
    return [time?.toDouble(), ax, ay, az, wx, wy, wz, roll, pitch, yaw];
  }
}
