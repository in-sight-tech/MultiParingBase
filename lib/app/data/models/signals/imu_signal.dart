import 'package:multiparingbase/app/data/models/signals/signal_base.dart';

class ImuSignal extends SignalBase {
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

  ImuSignal({this.time});

  @override
  List<double?> toList() {
    List<double?> list = [];

    list.add(time?.toDouble());

    if (ax != null) {
      list.addAll([ax, ay, az]);
    }
    if (wx != null) {
      list.addAll([wx, wy, wz]);
    }
    if (roll != null) {
      list.addAll([roll, pitch, yaw]);
    }

    return list;
  }

  @override
  String toString() {
    return '$time, $ax, $ay, $az, $wx, $wy, $wz, $roll, $pitch, $yaw';
  }
}
