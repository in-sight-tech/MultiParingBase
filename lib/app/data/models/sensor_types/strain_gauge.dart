import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGauge extends SensorBase {
  late StrainGaugeSignal signal;

  final Function(StrainGauge, StrainGaugeSignal)? onData;
  final Function(StrainGauge)? dispose;

  int? predictTime;
  int? biasTime;

  String unit = 'mm';

  Mode mode = Mode.normal;

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
        switch (mode) {
          case Mode.normal:
            normalMode(packets);
            break;
          case Mode.command:
            commandMode(packets);
            break;
          default:
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

  void normalMode(Uint8List packets) {
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
  }

  void commandMode(Uint8List packets) {
    String.fromCharCodes(packets).endsWith('<');
    if (String.fromCharCodes(packets) == '<sr>') {
      writeReg(data: 'end');
    } else if (String.fromCharCodes(packets) == '<record,true>') {
    } else if (String.fromCharCodes(packets) == '<record,false>') {}
    mode = Mode.normal;
  }

  void calSignal(ByteData bytes) async {
    signal = StrainGaugeSignal();

    biasTime ??= bytes.getInt32(1, Endian.little);
    signal.time = bytes.getInt32(1, Endian.little) - biasTime!;
    predictTime ??= signal.time! + tick;

    signal.value = bytes.getInt16(5, Endian.little).toDouble() / 4096.0 * 3.3;

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
  Future<bool> setSamplingRate(int samplingRate) async {
    await writeReg(data: 'sr,$samplingRate');

    return true;
  }

  Future<void> writeReg({required dynamic data, int delayMs = 0}) async {
    mode = Mode.command;
    connection?.output.add(Uint8List.fromList("<$data>".codeUnits));
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  void start() {
    biasTime = null;
    predictTime = null;

    writeReg(data: 'record,${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}');
  }

  @override
  void stop() {
    writeReg(data: 'record,false');
  }
}
