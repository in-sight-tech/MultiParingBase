class Data9Axis {
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

  Data9Axis({this.time});

  @override
  String toString() {
    return '$time, $ax, $ay, $az, $wx, $wy, $wz, $roll, $pitch, $yaw';
  }

  factory Data9Axis.copyWith(Data9Axis copy) => Data9Axis()
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
