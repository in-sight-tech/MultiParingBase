import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String? name;
  final BluetoothDevice device;
  final int? rssi;

  const BluetoothDeviceListEntry({
    Key? key,
    this.name,
    required this.device,
    this.rssi,
    this.onTap,
  }) : super(key: key);

  @override
  State<BluetoothDeviceListEntry> createState() => _BluetoothDeviceListEntryState();
}

class _BluetoothDeviceListEntryState extends State<BluetoothDeviceListEntry> {
  Widget icon = const SizedBox(height: double.infinity, child: Icon(Icons.sensors_rounded));
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap!();
      },
      leading: icon,
      title: Text(widget.name ?? widget.device.name ?? ""),
      subtitle: Text(widget.device.address.toString()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.rssi != null
              ? Container(
                  margin: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: _computeTextStyle(widget.rssi ?? 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.rssi.toString()),
                        const Text('dBm'),
                      ],
                    ),
                  ),
                )
              : const SizedBox(width: 0, height: 0),
          widget.device.isConnected ? const Icon(Icons.import_export) : const SizedBox(width: 0, height: 0),
          widget.device.isBonded ? const Icon(Icons.link) : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]);
    } else if (rssi >= -45) {
      return TextStyle(color: Color.lerp(Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    } else if (rssi >= -55) {
      return TextStyle(color: Color.lerp(Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    } else if (rssi >= -65) {
      return TextStyle(color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    } else if (rssi >= -75) {
      return TextStyle(color: Color.lerp(Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    } else if (rssi >= -85) {
      return TextStyle(color: Color.lerp(Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    } else {
      return const TextStyle(color: Colors.redAccent);
    }
  }
}
