import 'dart:async';

import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:lottie/lottie.dart';
import 'package:multiparingbase/app/data/enums.dart';
import 'package:permission_handler/permission_handler.dart';

class TypeSelector extends StatefulWidget {
  final Function(SensorType, DiscoveredDevice)? onTap;

  const TypeSelector({super.key, this.onTap});

  @override
  State<TypeSelector> createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector> {
  SensorType sensorTypeValue = SensorType.values[0];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Card(
            child: RadioListTile(
              value: SensorType.strainGauge,
              groupValue: sensorTypeValue,
              title: const Text('Strain Gauge'),
              onChanged: (value) => setState(() {
                sensorTypeValue = value!;
              }),
            ),
          ),
          Card(
            child: RadioListTile(
              value: SensorType.imu,
              groupValue: sensorTypeValue,
              title: const Text('IMU'),
              onChanged: (value) => setState(() {
                sensorTypeValue = value!;
              }),
            ),
          ),
          Card(
            child: RadioListTile(
              value: SensorType.analog,
              groupValue: sensorTypeValue,
              title: const Text('Analog'),
              onChanged: (value) => setState(() {
                sensorTypeValue = value!;
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {},
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () => DialogNavigator.of(context).push(
                  FluidDialogPage(
                    // This dialog is shown in the center of the screen.
                    alignment: Alignment.center,
                    // Using a custom decoration for this dialog.
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    builder: (context) => DeviceSelector(
                      sensorTypeValue: sensorTypeValue,
                      onTap: widget.onTap,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeviceSelector extends StatefulWidget {
  final SensorType sensorTypeValue;
  final Function(SensorType, DiscoveredDevice)? onTap;

  const DeviceSelector({
    super.key,
    this.onTap,
    required this.sensorTypeValue,
  });

  @override
  State<DeviceSelector> createState() => _DeviceSelectorState();
}

class _DeviceSelectorState extends State<DeviceSelector> {
  final flutterReactiveBle = FlutterReactiveBle();
  bool isDiscovering = true;
  final List<DiscoveredDevice> results = <DiscoveredDevice>[];
  late StreamSubscription<DiscoveredDevice> streamSubscription;
  DiscoveredDevice? sensorValue;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), init);

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  Future<void> init() async {
    await requestPermission();
    bluetoothDiscovery();
  }

  Future<void> requestPermission() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();
  }

  void update() {
    if (!mounted) return;
    setState(() {});
  }

  bluetoothDiscovery() {
    results.clear();
    update();

    streamSubscription = flutterReactiveBle.scanForDevices(withServices: []).listen((scanResult) {
      if (results.any((e) => e.id == scanResult.id) || scanResult.name.isEmpty) return;

      results.add(scanResult);
      update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => DialogNavigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Lottie.asset('assets/lotties/searching-for-bluetooth-devices.json', height: 50),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: RadioListTile(
                    value: results[index],
                    groupValue: sensorValue,
                    title: Text(results[index].name),
                    onChanged: (value) => setState(() {
                      sensorValue = value;
                    }),
                  ),
                ),
                itemCount: results.length,
                shrinkWrap: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: sensorValue == null ? null : () => widget.onTap?.call(widget.sensorTypeValue, sensorValue!),
                  child: const Text('Connect'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
