import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/models.dart';

class StrainGaugeSettingDialog extends StatefulWidget {
  final StrainGauge sensor;

  const StrainGaugeSettingDialog({super.key, required this.sensor});

  @override
  State<StrainGaugeSettingDialog> createState() => _StrainGaugeSettingDialogState();
}

class _StrainGaugeSettingDialogState extends State<StrainGaugeSettingDialog> {
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
              '${widget.sensor.device.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(),
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

                    await widget.sensor.setSamplingRate(value!);

                    if (mounted) Navigator.of(context).pop();
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
