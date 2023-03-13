import 'dart:async';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/enums.dart';

class TypeSelector extends StatefulWidget {
  final Function(SensorType, BluetoothDevice)? onTap;

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
          const Text(
            ' 센서 타입 선택',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...SensorType.values.where((e) => e != SensorType.gps).map(
                (e) => Card(
                  child: RadioListTile(
                    value: e,
                    groupValue: sensorTypeValue,
                    title: Text(e.displayName),
                    onChanged: (value) => setState(() {
                      sensorTypeValue = value!;
                    }),
                  ),
                ),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancel'),
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
  final Function(SensorType, BluetoothDevice)? onTap;

  const DeviceSelector({
    super.key,
    this.onTap,
    required this.sensorTypeValue,
  });

  @override
  State<DeviceSelector> createState() => _DeviceSelectorState();
}

class _DeviceSelectorState extends State<DeviceSelector> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  bool isDiscovering = true;
  final List<ScanResult> results = <ScanResult>[];
  late StreamSubscription<List<ScanResult>> streamSubscription;
  ScanResult? sensorValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    streamSubscription.cancel();
    super.dispose();
  }

  Future<void> init() async {
    await requestPermission();
    bluetoothDiscovery();
  }

  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    Logger().d(statuses);
  }

  void update() {
    if (!mounted) return;
    setState(() {});
  }

  bluetoothDiscovery() {
    results.clear();
    update();

    flutterBlue.startScan();

    streamSubscription = flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        if (this.results.contains(result) || result.device.name.isEmpty) continue;

        this.results.add(result);
        update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
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
                const Text(
                  '센서 선택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isDiscovering) Lottie.asset('assets/lotties/searching-for-bluetooth-devices.json', height: 50),
              ],
            ),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: RadioListTile(
                    value: results[index],
                    groupValue: sensorValue,
                    title: Text(results[index].device.name),
                    subtitle: Text('${results[index].device.id}'),
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
                  onPressed: sensorValue == null ? null : () => widget.onTap?.call(widget.sensorTypeValue, sensorValue!.device),
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
