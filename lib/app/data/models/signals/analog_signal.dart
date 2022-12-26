import 'package:multiparingbase/app/data/models/signals.dart';

class AnalogSignal extends SignalBase {
  int? time;
  double? value;

  AnalogSignal({this.time});

  @override
  List<double?> toList() {
    List<double?> list = [];

    list.add(time?.toDouble());

    if (value != null) {
      list.add(value);
    }

    return list;
  }

  @override
  String toString() {
    return '$time, $value';
  }
}
