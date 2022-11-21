import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/collections/data_9axis.dart';

class IMUTile extends StatefulWidget {
  final String title;
  final String unit;
  final Function()? onSetting;
  final Function()? onClose;
  final List<SensorSignal> signal;

  const IMUTile({
    super.key,
    required this.title,
    this.onClose,
    required this.signal,
    this.onSetting,
    required this.unit,
  });

  @override
  State<IMUTile> createState() => _IMUTileState();
}

class _IMUTileState extends State<IMUTile> {
  int? value = 0;
  late String unit;

  List<FlSpot> get ax => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].ax == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].ax!,
            )
      ];

  List<FlSpot> get ay => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].ay == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].ay!,
            )
      ];

  List<FlSpot> get az => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].az == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].az!,
            )
      ];

  List<FlSpot> get wx => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].wx == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].wx!,
            )
      ];

  List<FlSpot> get wy => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].wy == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].wy!,
            )
      ];

  List<FlSpot> get wz => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].wz == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].wz!,
            )
      ];

  List<FlSpot> get roll => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].roll == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].roll!,
            )
      ];

  List<FlSpot> get pitch => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].pitch == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].pitch!,
            )
      ];

  List<FlSpot> get yaw => [
        for (int i = 0; i < widget.signal.length; i++)
          if (widget.signal[i].yaw == null)
            FlSpot.nullSpot
          else
            FlSpot(
              i.toDouble(),
              widget.signal[i].yaw!,
            )
      ];

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
