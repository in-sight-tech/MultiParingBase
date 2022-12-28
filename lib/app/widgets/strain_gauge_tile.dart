import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGaugeTile extends StatelessWidget {
  final StrainGauge sensor;
  final List<StrainGaugeSignal> signal;

  const StrainGaugeTile({
    super.key,
    required this.sensor,
    required this.signal,
  });

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
                  sensor.device.name,
                  style: const TextStyle(fontSize: 25),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => StrainGaugeSettingDialog(
                      sensor: sensor,
                    ),
                  ),
                  icon: const Icon(Icons.settings),
                ),
                CloseButton(onPressed: sensor.disconnect),
              ],
            ),
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.all(10),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (int i = 0; i < signal.length; i++)
                        if (signal[i].value == null)
                          FlSpot.nullSpot
                        else
                          FlSpot(
                            i.toDouble(),
                            signal[i].value!,
                          )
                    ],
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 0.5,
                    color: Colors.red,
                  ),
                ],
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(sensor.unit),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(3)),
                    ),
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

class StrainGaugeSettingDialog extends StatefulWidget {
  final StrainGauge sensor;

  const StrainGaugeSettingDialog({super.key, required this.sensor});

  @override
  State<StrainGaugeSettingDialog> createState() => _StrainGaugeSettingDialogState();
}

class _StrainGaugeSettingDialogState extends State<StrainGaugeSettingDialog> {
  bool isWaiting = false;
  int? returnRateValue;

  @override
  void initState() {
    super.initState();
    returnRateValue = widget.sensor.samplingRate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.sensor.device.name,
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(),
            Column(
              children: [
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
                      onChanged: (value) {
                        isWaiting = true;
                        returnRateValue = value;

                        widget.sensor.setSamplingRate(value!);

                        setState(() => {});
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    isWaiting = true;
                    widget.sensor.calibrate();
                    setState(() => {});
                  },
                  child: const Text('Calibrate'),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Calibration Value',
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (String value) {
                    widget.sensor.setCalibrationValue(double.parse(value));
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'DeviceName',
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (String value) {
                    widget.sensor.setName(value);
                  },
                ),
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
