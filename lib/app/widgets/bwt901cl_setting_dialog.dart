import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/sensor_types/bwt901cl.dart';

class BWT901ClSettingDialog extends StatefulWidget {
  final BWT901CL sensor;

  const BWT901ClSettingDialog({
    super.key,
    required this.sensor,
  });

  @override
  State<BWT901ClSettingDialog> createState() => _BWT901ClSettingDialogState();
}

class _BWT901ClSettingDialogState extends State<BWT901ClSettingDialog> {
  String? unitValue;

  int? returnRateValue;

  late ReturnContents returnContentsValue;

  @override
  void initState() {
    super.initState();

    unitValue = widget.sensor.accelerationUnit;
    returnRateValue = widget.sensor.frequency;
    returnContentsValue = widget.sensor.returnContents;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sensor.device.name ?? '',
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(),
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
                    widget.sensor.setUnit(unitValue!);
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Return Rate : '),
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

                    await widget.sensor.setSamplingRate(value!);

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
                  label: const Text('Accelertaion'),
                  selected: returnContentsValue.acceleration,
                  selectedColor: Colors.lightBlue,
                  onSelected: (value) async {
                    setState(() => returnContentsValue.acceleration = value);
                    showProgressDialog();
                    await widget.sensor.setReturnContent(returnContentsValue);

                    if (mounted) Navigator.of(context).pop();
                  },
                ),
                ChoiceChip(
                  label: const Text('Angular velocity'),
                  selected: returnContentsValue.angularVelocity,
                  selectedColor: Colors.lightBlue,
                  onSelected: (value) async {
                    setState(() => returnContentsValue.angularVelocity = value);
                    showProgressDialog();
                    await widget.sensor.setReturnContent(returnContentsValue);
                    if (mounted) Navigator.of(context).pop();
                  },
                ),
                ChoiceChip(
                  label: const Text('Angle'),
                  selected: returnContentsValue.angle,
                  selectedColor: Colors.lightBlue,
                  onSelected: (value) async {
                    setState(() => returnContentsValue.angle = value);
                    showProgressDialog();
                    await widget.sensor.setReturnContent(returnContentsValue);
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
                      await widget.sensor.calibrate();
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
