import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/imu.dart';

class IMUTile extends StatefulWidget {
  final String title;
  final String unit;
  final Function()? onSetting;
  final Function()? onClose;
  final List<List<double?>> signal;
  final List<String> contents;

  const IMUTile({
    super.key,
    required this.title,
    this.onClose,
    required this.signal,
    this.onSetting,
    required this.unit,
    required this.contents,
  });

  @override
  State<IMUTile> createState() => _IMUTileState();
}

class _IMUTileState extends State<IMUTile> {
  int? value = 0;
  late String unit;

  List<FlSpot>? get ax {
    int index = widget.contents.indexOf('acc.x');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get ay {
    int index = widget.contents.indexOf('acc.y');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get az {
    int index = widget.contents.indexOf('acc.z');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get wx {
    int index = widget.contents.indexOf('w.x');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get wy {
    int index = widget.contents.indexOf('w.y');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get wz {
    int index = widget.contents.indexOf('w.z');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get roll {
    int index = widget.contents.indexOf('roll');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get pitch {
    int index = widget.contents.indexOf('pitch');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  List<FlSpot>? get yaw {
    int index = widget.contents.indexOf('yaw');

    if (index == -1) return null;

    return [
      for (int i = 0; i < widget.signal.length; i++)
        if (widget.signal[i][index] == null)
          FlSpot.nullSpot
        else
          FlSpot(
            i.toDouble(),
            widget.signal[i][index]!,
          )
    ];
  }

  @override
  initState() {
    super.initState();

    unit = widget.unit;
  }

  @override
  void didUpdateWidget(covariant IMUTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (value == 0) {
      unit = widget.unit;
    } else if (value == 1) {
      unit = '°/s';
    } else if (value == 2) {
      unit = '°';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 25),
                ),
                const Spacer(),
                IconButton(onPressed: widget.onSetting?.call, icon: const Icon(Icons.settings)),
                CloseButton(onPressed: widget.onClose?.call),
              ],
            ),
          ),
          CupertinoSlidingSegmentedControl(
            children: const {
              0: Text('Acceleration'),
              1: Text('Angular velocity'),
              2: Text('Angle'),
            },
            groupValue: value,
            onValueChanged: (int? newValue) {
              setState(() => value = newValue);
            },
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.all(10),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  if (value == 0)
                    LineChartBarData(
                      spots: ax,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.red,
                    ),
                  if (value == 0)
                    LineChartBarData(
                      spots: ay,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.green,
                    ),
                  if (value == 0)
                    LineChartBarData(
                      spots: az,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.blue,
                    ),
                  if (value == 1)
                    LineChartBarData(
                      spots: wx,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.red,
                    ),
                  if (value == 1)
                    LineChartBarData(
                      spots: wy,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.green,
                    ),
                  if (value == 1)
                    LineChartBarData(
                      spots: wz,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.blue,
                    ),
                  if (value == 2)
                    LineChartBarData(
                      spots: roll,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.red,
                    ),
                  if (value == 2)
                    LineChartBarData(
                      spots: pitch,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.green,
                    ),
                  if (value == 2)
                    LineChartBarData(
                      spots: yaw,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 0.5,
                      color: Colors.blue,
                    )
                ],
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(unit),
                    sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                  ),
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  bottomTitles: AxisTitles(),
                ),
              ),
              swapAnimationDuration: Duration.zero,
            ),
          ),
        ],
      ),
    );
  }
}
