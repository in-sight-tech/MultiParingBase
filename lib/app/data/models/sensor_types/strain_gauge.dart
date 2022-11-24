import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGauge extends SensorBase {
  late StrainGaugeSignal signal;

  final Function(StrainGauge, StrainGaugeSignal)? onData;
  final Function(StrainGauge)? dispose;

  int? predictTime;
  int? biasTime;

  String unit = 'mm';

  StrainGauge({
    required BluetoothDevice device,
    this.onData,
    this.dispose,
  }) {
    super.device = device;
    frequency = 100;
    tick = 1000 ~/ frequency;
  }

  @override
  Future<bool> connect() async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);

      if (connection?.isConnected == false) throw 'Connect error';

      connection?.input?.listen((Uint8List packets) {
        for (int byte in packets) {
          if (byte != 0x55) {
            buffer.addByte(byte);
            continue;
          }

          if (buffer.length != 8) {
            buffer.clear();
            buffer.addByte(byte);
            continue;
          }

          if (!isValiable(buffer.toBytes())) {
            buffer.clear();
            continue;
          }

          calSignal(buffer.takeBytes().buffer.asByteData());
          buffer.clear();

          buffer.addByte(byte);
        }
      }).onDone(() {
        dispose?.call(this);
      });

      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  void calSignal(ByteData bytes) async {
    signal = StrainGaugeSignal();

    biasTime ??= bytes.getInt32(1, Endian.little);
    signal.time = bytes.getInt32(1, Endian.little) - biasTime!;
    predictTime ??= signal.time! + tick;

    signal.value = bytes.getInt16(5, Endian.little).toDouble();

    if (predictTime == signal.time) {
      predictTime = predictTime! + tick;

      onData?.call(this, signal);
    } else {
      while (predictTime! < signal.time!) {
        onData?.call(this, StrainGaugeSignal(time: predictTime));
        predictTime = predictTime! + tick;
      }

      onData?.call(this, signal);
      predictTime = predictTime! + tick;
    }
  }

  @override
  void disconnect() {
    connection?.dispose();
  }

  @override
  void start() {
    biasTime = null;
    predictTime = null;
  }

  @override
  Future<bool> setReturnRate(int frequency) async {
    await writeReg(addr: 0x03, data: frequency, delayMs: 100);

    return true;
  }

  @override
  Future<void> writeReg({required int addr, required dynamic data, int delayMs = 0}) async {
    connection?.output.add(Uint8List.fromList(['<'.codeUnitAt(0), 0x01, data & 0xff, (data >> 8) & 0xff, '>'.codeUnitAt(0)]));
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}
