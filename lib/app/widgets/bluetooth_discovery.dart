import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:multiparingbase/app/widgets/bluetooth_device_list_entry.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothDiscovery extends StatefulWidget {
  final Function(BluetoothDevice)? onTap;

  const BluetoothDiscovery({
    super.key,
    this.onTap,
  });

  @override
  State<BluetoothDiscovery> createState() => _BluetoothDiscoveryState();
}

class _BluetoothDiscoveryState extends State<BluetoothDiscovery> {
  bool isDiscovering = true;
  final List<BluetoothDiscoveryResult> results = <BluetoothDiscoveryResult>[];
  StreamSubscription<BluetoothDiscoveryResult>? streamSubscription;

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.cancelDiscovery();

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
    isDiscovering = true;
    update();

    streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      final existingIndex = results.indexWhere((element) => element.device.address == r.device.address);
      if (existingIndex >= 0) {
        results[existingIndex] = r;
      } else {
        results.add(r);
      }
      update();
    });

    streamSubscription?.onDone(() {
      isDiscovering = false;
      update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              return BluetoothDeviceListEntry(
                device: results[index].device,
                onTap: () {
                  widget.onTap?.call(results[index].device);
                },
              );
            },
          ),
          if (isDiscovering) const Center(child: CircularProgressIndicator()),
          if (!isDiscovering) TextButton(onPressed: bluetoothDiscovery, child: const Text('다시 검색'))
        ],
      ),
    );
  }
}
