import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class ImuTile extends StatefulWidget {
  final Imu sensor;
  final List<ImuSignal> signal;

  const ImuTile({
    super.key,
    required this.signal,
    required this.sensor,
  });

  @override
  State<ImuTile> createState() => _ImuTileState();
}

class _ImuTileState extends State<ImuTile> {
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

    unit = widget.sensor.unit;
  }

  @override
  void didUpdateWidget(covariant ImuTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (value == 0) {
      unit = widget.sensor.unit;
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
                  widget.sensor.device.name,
                  style: const TextStyle(fontSize: 25),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ImuSettingDialog(
                      sensor: widget.sensor,
                    ),
                  ),
                  icon: const Icon(Icons.settings),
                ),
                CloseButton(onPressed: widget.sensor.disconnect),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('Sampling Rate: ${widget.sensor.samplingRate}Hz'),
              ],
            ),
          ),
          CupertinoSlidingSegmentedControl(
            children: {
              0: Text('Acceleration', style: TextStyle(color: widget.sensor.contents?.acceleration ?? false ? Colors.black : Colors.grey)),
              1: Text('Angular velocity', style: TextStyle(color: widget.sensor.contents?.gyro ?? false ? Colors.black : Colors.grey)),
              2: Text('Angle', style: TextStyle(color: widget.sensor.contents?.angle ?? false ? Colors.black : Colors.grey)),
            },
            groupValue: value,
            onValueChanged: (int? newValue) {
              if (widget.sensor.contents?.config & pow(2, newValue! + 1) == 0) return;
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
                lineTouchData: LineTouchData(enabled: false),
              ),
              swapAnimationDuration: Duration.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class ImuSettingDialog extends StatefulWidget {
  final Imu sensor;

  const ImuSettingDialog({
    super.key,
    required this.sensor,
  });

  @override
  State<ImuSettingDialog> createState() => _ImuSettingDialogState();
}

class _ImuSettingDialogState extends State<ImuSettingDialog> {
  final _nameController = TextEditingController();
  String? unitValue;

  int? returnRateValue;

  late ImuSettings returnContentsValue;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.sensor.device.name;
    unitValue = widget.sensor.unit == 'm/s^2' ? 'm/s²' : 'g';
    returnRateValue = widget.sensor.samplingRate;
    returnContentsValue = widget.sensor.contents ?? ImuSettings(3);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: _nameController,
              maxLength: 16,
              decoration: const InputDecoration(
                labelText: 'DeviceName',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
                helperText: 'Reboot required when renaming sensor',
                helperStyle: TextStyle(fontSize: 10, color: Colors.red),
              ),
              keyboardType: TextInputType.text,
              onSubmitted: (String value) {
                widget.sensor.setName(value);
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Unit : '),
                CupertinoSlidingSegmentedControl<String>(
                  children: const {
                    'm/s²': Text('m/s²'),
                    'g': Text('g'),
                  },
                  groupValue: unitValue,
                  onValueChanged: (String? newValue) {
                    setState(() => unitValue = newValue);
                    widget.sensor.unit = newValue!;
                    widget.sensor.setUnit(unitValue == 'g' ? 'g' : 'm/s^2');
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Sampling Rate : '),
                DropdownButton<int>(
                  value: returnRateValue,
                  alignment: AlignmentDirectional.centerEnd,
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(value: 1, alignment: AlignmentDirectional.centerEnd, child: Text('1 Hz')),
                    DropdownMenuItem(value: 2, alignment: AlignmentDirectional.centerEnd, child: Text('2 Hz')),
                    DropdownMenuItem(value: 5, alignment: AlignmentDirectional.centerEnd, child: Text('5 Hz')),
                    DropdownMenuItem(value: 10, alignment: AlignmentDirectional.centerEnd, child: Text('10 Hz')),
                    DropdownMenuItem(value: 20, alignment: AlignmentDirectional.centerEnd, child: Text('20 Hz')),
                    DropdownMenuItem(value: 50, alignment: AlignmentDirectional.centerEnd, child: Text('50 Hz')),
                    DropdownMenuItem(value: 100, alignment: AlignmentDirectional.centerEnd, child: Text('100 Hz')),
                    DropdownMenuItem(value: 200, alignment: AlignmentDirectional.centerEnd, child: Text('200 Hz')),
                  ],
                  onChanged: (value) async {
                    setState(() => returnRateValue = value);

                    showProgressDialog();

                    widget.sensor.samplingRate = value!;
                    widget.sensor.setSamplingRate(value);

                    if (mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Return content'),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: [
                ChoiceChip(
                  label: Text(
                    'Accelertaion',
                    style: TextStyle(color: widget.sensor.contents?.acceleration ?? false ? Colors.grey[200] : Colors.black),
                  ),
                  selected: widget.sensor.contents!.acceleration,
                  selectedColor: Colors.lightBlue,
                  onSelected: (value) async {
                    setState(() => widget.sensor.contents!.acceleration = value);
                    showProgressDialog();
                    widget.sensor.setReturnContent(widget.sensor.contents!);

                    if (mounted) Navigator.of(context).pop();
                  },
                ),
                ChoiceChip(
                  label: Text(
                    'Angular velocity',
                    style: TextStyle(color: widget.sensor.contents!.gyro ? Colors.grey[200] : Colors.black),
                  ),
                  selected: widget.sensor.contents!.gyro,
                  selectedColor: Colors.lightBlue,
                  onSelected: (value) async {
                    setState(() => widget.sensor.contents!.gyro = value);
                    showProgressDialog();
                    widget.sensor.setReturnContent(widget.sensor.contents!);
                    if (mounted) Navigator.of(context).pop();
                  },
                ),
                ChoiceChip(
                  label: Text(
                    'Angle',
                    style: TextStyle(color: widget.sensor.contents!.angle ? Colors.grey[200] : Colors.black),
                  ),
                  selected: widget.sensor.contents!.angle,
                  selectedColor: Colors.lightBlue,
                  onSelected: (value) async {
                    setState(() => widget.sensor.contents!.angle = value);
                    showProgressDialog();
                    widget.sensor.setReturnContent(widget.sensor.contents!);
                    if (mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Calibrate : '),
                CupertinoButton(
                    onPressed: () async {
                      showProgressDialog();
                      widget.sensor.calibrate();
                      if (mounted) Navigator.of(context).pop();
                    },
                    child: const Text('Acceleration')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const SizedBox(
            width: 200,
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
