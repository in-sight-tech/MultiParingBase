import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:multiparingbase/app/data/enums.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothDiscovery extends StatefulWidget {
  final Function(SensorType, BluetoothDevice)? onTap;

  const BluetoothDiscovery({
    super.key,
    this.onTap,
  });

  @override
  State<BluetoothDiscovery> createState() => _BluetoothDiscoveryState();
}

class _BluetoothDiscoveryState extends State<BluetoothDiscovery> {
  int stepperIndex = 0;
  SensorType? sensorTypeValue = SensorType.values[0];
  BluetoothDevice? sensorValue;

  bool isDiscovering = true;
  final List<ScanResult> results = <ScanResult>[];
  StreamSubscription<List<ScanResult>>? streamSubscription;

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  void dispose() {
    FlutterBluePlus.instance.stopScan();

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

    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.instance.isScanning.listen((isScanning) {
      if (isScanning) {
        isDiscovering = true;
        update();
      }
      if (!isScanning) {
        isDiscovering = false;
        update();
      }
    });

    streamSubscription = FlutterBluePlus.instance.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!this.results.contains(r) && r.device.name.isNotEmpty) {
          this.results.add(r);
          update();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 500,
      child: Stepper(
        currentStep: stepperIndex,
        onStepCancel: () {
          if (stepperIndex > 0) {
            setState(() {
              stepperIndex -= 1;
            });
          }
        },
        onStepContinue: () {
          if (stepperIndex <= 0) {
            setState(() {
              stepperIndex += 1;
            });
          } else {
            if (sensorValue == null) return;
            widget.onTap?.call(sensorTypeValue!, sensorValue!);
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(stepperIndex == 1 ? 'Connect' : 'Continue'),
              ),
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('Back'),
              ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('Select Sensor Type'),
            isActive: stepperIndex == 0,
            content: Container(
              alignment: Alignment.center,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Card(
                    child: RadioListTile(
                      value: SensorType.strainGauge,
                      groupValue: sensorTypeValue,
                      title: const Text('Strain Gauge'),
                      onChanged: (value) => setState(() {
                        sensorTypeValue = value;
                      }),
                    ),
                  ),
                  Card(
                    child: RadioListTile(
                      value: SensorType.imu,
                      groupValue: sensorTypeValue,
                      title: const Text('IMU'),
                      onChanged: (value) => setState(() {
                        sensorTypeValue = value;
                      }),
                    ),
                  ),
                  Card(
                    child: RadioListTile(
                      value: SensorType.analog,
                      groupValue: sensorTypeValue,
                      title: const Text('Analog'),
                      onChanged: (value) => setState(() {
                        sensorTypeValue = value;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Select Sensor'),
            isActive: stepperIndex == 1,
            content: SizedBox(
              height: 280,
              child: ListView(
                children: [
                  ...results.map((r) => Card(
                        child: RadioListTile(
                          value: r.device,
                          groupValue: sensorValue,
                          title: Text(r.device.name),
                          onChanged: (value) => setState(() {
                            sensorValue = value;
                          }),
                        ),
                      )),
                  if (isDiscovering)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (!isDiscovering)
                    TextButton(
                      onPressed: bluetoothDiscovery,
                      child: const Text('다시 검색'),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
