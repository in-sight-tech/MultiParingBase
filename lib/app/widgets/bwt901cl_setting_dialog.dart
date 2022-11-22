import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/sensor_types/bwt901cl.dart';

class IMUSettingDialog extends StatefulWidget {
  final String unit;
  final Function(String) setUnit;
  final int returnRate;
  final Function(int) setReturnRate;
  final Function() calibrate;
  final ReturnContents returnContents;
  final Function(ReturnContents) setReturnContents;

  const IMUSettingDialog({
    super.key,
    required this.unit,
    required this.setUnit,
    required this.returnRate,
    required this.setReturnRate,
    required this.returnContents,
    required this.setReturnContents,
    required this.calibrate,
  });

  @override
  State<IMUSettingDialog> createState() => _IMUSettingDialogState();
}

class _IMUSettingDialogState extends State<IMUSettingDialog> {
  String? unitValue;

  int? returnRateValue;

  late ReturnContents returnContentsValue;

  @override
  void initState() {
    super.initState();

    unitValue = widget.unit;
    returnRateValue = widget.returnRate;
    returnContentsValue = widget.returnContents;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  widget.setUnit.call(unitValue!);
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
                onChanged: (value) {
                  setState(() => returnRateValue = value);
                  widget.setReturnRate.call(value!);
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
                onSelected: (value) {
                  setState(() => returnContentsValue.acceleration = value);
                  widget.setReturnContents.call(returnContentsValue);
                },
              ),
              ChoiceChip(
                label: const Text('Angular velocity'),
                selected: returnContentsValue.angularVelocity,
                selectedColor: Colors.lightBlue,
                onSelected: (value) {
                  setState(() => returnContentsValue.angularVelocity = value);
                  widget.setReturnContents.call(returnContentsValue);
                },
              ),
              ChoiceChip(
                label: const Text('Angle'),
                selected: returnContentsValue.angle,
                selectedColor: Colors.lightBlue,
                onSelected: (value) {
                  setState(() => returnContentsValue.angle = value);
                  widget.setReturnContents.call(returnContentsValue);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Calibrate : '),
              CupertinoButton(onPressed: widget.calibrate, child: const Text('Acceleration')),
            ],
          ),
        ],
      ),
    );
  }
}
