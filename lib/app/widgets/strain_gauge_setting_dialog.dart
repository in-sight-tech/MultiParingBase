import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/models.dart';

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

    widget.sensor.onResponse = () {
      isWaiting = false;
      if (mounted) setState(() => {});
    };

    widget.sensor.onError = () {
      isWaiting = false;
      if (mounted) setState(() => {});
    };
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
            if (isWaiting == true)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (isWaiting == false)
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
                  ElevatedButton(
                    onPressed: () {
                      isWaiting = true;
                      widget.sensor.transferFile();
                      setState(() => {});
                    },
                    child: const Text('request'),
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
