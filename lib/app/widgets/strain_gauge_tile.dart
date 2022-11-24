import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';
import 'package:multiparingbase/app/widgets/strain_gauge_setting_dialog.dart';

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
                  sensor.device.name ?? '',
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
