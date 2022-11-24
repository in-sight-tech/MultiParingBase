import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/models.dart';

class StrainGaugeSettingDialog extends StatefulWidget {
  final StrainGauge sensor;

  const StrainGaugeSettingDialog({super.key, required this.sensor});

  @override
  State<StrainGaugeSettingDialog> createState() => _StrainGaugeSettingDialogState();
}

class _StrainGaugeSettingDialogState extends State<StrainGaugeSettingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 200,
        height: 300,
        child: Row(
          children: [
            TextButton(
              onPressed: () async {
                widget.sensor.setReturnRate(100);
              },
              child: Text('adsf'),
            )
          ],
        ),
      ),
    );
  }
}
