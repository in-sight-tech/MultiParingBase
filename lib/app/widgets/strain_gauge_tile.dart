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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('Sampling Rate: ${sensor.samplingRate}Hz'),
                const SizedBox(width: 20),
                Text('Cal Value: ${sensor.calValue}'),
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
  int? returnRateValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _calibrationController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _displacementController1 = TextEditingController();
  final TextEditingController _displacementController2 = TextEditingController();
  final TextEditingController _inputSignalController1 = TextEditingController();
  final TextEditingController _inputSignalController2 = TextEditingController();
  bool isCalibration = false;

  @override
  void initState() {
    super.initState();
    returnRateValue = widget.sensor.samplingRate;
    _nameController.text = widget.sensor.device.name;
    _calibrationController.text = widget.sensor.calValue.toStringAsFixed(2);
    _unitController.text = widget.sensor.unit;

    _displacementController1.text = widget.sensor.displacement1.toStringAsFixed(2);
    _displacementController2.text = widget.sensor.displacement2.toStringAsFixed(2);
    _inputSignalController1.text = widget.sensor.inputSignal1.toStringAsFixed(2);
    _inputSignalController2.text = widget.sensor.inputSignal2.toStringAsFixed(2);
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
            TextField(
              controller: _unitController,
              decoration: const InputDecoration(
                prefixText: 'Unit : ',
                border: InputBorder.none,
                prefixIconColor: Colors.black,
              ),
              onSubmitted: (String value) {
                widget.sensor.unit = value;
                widget.sensor.setUnit(value);
              },
            ),
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
                    returnRateValue = value;

                    widget.sensor.setSamplingRate(value!);

                    setState(() => {});
                  },
                ),
              ],
            ),
            isCalibration
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      widget.sensor.calibrate();
                      isCalibration = true;
                      Future.delayed(const Duration(seconds: 3), () => setState(() => isCalibration = false));
                      setState(() => {});
                    },
                    child: const Text('Calibrate'),
                  ),
            TextField(
              controller: _calibrationController,
              decoration: const InputDecoration(
                prefixText: 'Calibration Value : ',
                border: InputBorder.none,
                prefixIconColor: Colors.black,
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (String value) {
                widget.sensor.calValue = double.parse(value);
                widget.sensor.setCalibrationValue(double.parse(value));
              },
            ),
            const Text('Calibration Table'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _displacementController1,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Displacement',
                      suffixText: widget.sensor.unit,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    ),
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String value) {
                      widget.sensor.calValue = double.parse(value);
                      widget.sensor.setDisplacement1(double.parse(value));
                    },
                  ),
                ),
                const Text(' == '),
                Expanded(
                  child: TextField(
                    controller: _inputSignalController1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(gapPadding: 0),
                      suffixText: 'volts',
                      labelText: 'Input Signal',
                      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    ),
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String value) {
                      widget.sensor.calValue = double.parse(value);
                      widget.sensor.setImputSignal1(double.parse(value));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _displacementController2,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Displacement',
                      suffixText: widget.sensor.unit,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    ),
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String value) {
                      widget.sensor.calValue = double.parse(value);
                      widget.sensor.setDisplacement2(double.parse(value));
                    },
                  ),
                ),
                const Text(' == '),
                Expanded(
                  child: TextField(
                    controller: _inputSignalController2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(gapPadding: 0),
                      suffixText: 'volts',
                      labelText: 'Input Signal',
                      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    ),
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String value) {
                      widget.sensor.calValue = double.parse(value);
                      widget.sensor.setImputSignal2(double.parse(value));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
