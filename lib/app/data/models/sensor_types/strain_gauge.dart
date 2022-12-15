import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class StrainGauge extends SensorBase {
  late StrainGaugeSignal signal;

  final Function(StrainGauge, StrainGaugeSignal)? onRealTimeSignal;
  final Function(StrainGauge, List<StrainGaugeSignal>)? onData;
  final Function(StrainGauge)? dispose;

  void Function()? onResponse;
  void Function()? onError;

  int? predictTime;
  int? biasTime;

  int? preByte;

  String unit = 'mm';

  Mode _mode = Mode.normal;

  Mode get mode => _mode;

  set mode(Mode mode) {
    _mode = mode;
    buffer.clear();
  }

  Logger logger = Logger();

  StrainGauge({
    required BluetoothDevice device,
    this.onData,
    this.dispose,
    this.onRealTimeSignal,
  }) {
    super.device = device;
    samplingRate = 100;
    tick = 1000 ~/ samplingRate;
  }

  @override
  Future<bool> connect() async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);

      if (connection?.isConnected == false) throw 'Connect error';

      connection?.input?.listen((Uint8List packets) {
        if (packets.isEmpty) return;

        switch (mode) {
          case Mode.normal:
            normalMode(packets);
            break;
          case Mode.command:
            commandMode(packets);
            break;
          case Mode.fileTransfer:
            fileTransferMode(packets);
            break;
        }
      }).onDone(() {
        dispose?.call(this);
      });

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  void normalMode(Uint8List packets) {
    for (int byte in packets) {
      while (buffer.length > 9) {
        if (buffer[0] == 0x55 && buffer[1] == 0x55) {
          logger.i(buffer.map((e) => '0x${e.toRadixString(16)}'));
          calSignal(ByteData.view(Uint8List.fromList(buffer).buffer));
          buffer.clear();
        } else {
          buffer.removeAt(0);
        }
      }
      buffer.add(byte);
    }
  }

  void calSignal(ByteData bytes) async {
    signal = StrainGaugeSignal();

    biasTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - biasTime!;
    predictTime ??= signal.time! + tick;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3;

    if (predictTime == signal.time) {
      predictTime = predictTime! + tick;

      onRealTimeSignal?.call(this, signal);
    } else {
      while (predictTime! < signal.time!) {
        onRealTimeSignal?.call(this, StrainGaugeSignal(time: predictTime));
        predictTime = predictTime! + tick;
      }

      onRealTimeSignal?.call(this, signal);
      predictTime = predictTime! + tick;
    }
  }

  @override
  void disconnect() {
    connection?.dispose();
  }

  // ! Command 부분
  void commandMode(Uint8List packets) {
    // for (int byte in packets) {
    //   if (byte == 60) {
    //     buffer.clear();
    //   }

    //   buffer.addByte(byte);

    //   if (byte == 62) {
    //     String command = String.fromCharCodes(buffer.toBytes());

    //     logger.i(command);

    //     if (command == '<er>') {
    //       responseError();
    //     } else if (command == '<ok>') {
    //       responseOk();
    //     }

    //     buffer.clear();
    //   }
    // }
  }

  void responseOk() {
    mode = Mode.normal;
    onResponse?.call();
  }

  void responseError() {
    writeReg(data: '<error>');
    logger.i('error');
    onError?.call();
  }

  Future<void> writeReg({required dynamic data, int delayMs = 0}) async {
    mode = Mode.command;
    connection?.output.add(Uint8List.fromList("$data".codeUnits));
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  void setSamplingRate(int samplingRate) => writeReg(data: '<sor,$samplingRate>');

  @override
  void start() => writeReg(data: '<si,${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');

  @override
  void stop() => writeReg(data: '<eoi>');

  void transferFile() async {
    writeReg(data: '<ftr>');
    mode = Mode.fileTransfer;
  }

  void calibrate() => writeReg(data: '<zc>');

  // ! File Transfer mode
  void fileTransferMode(Uint8List packets) {
    // for (int byte in packets) {
    //   if (byte != 0x55) {
    //     buffer.addByte(byte);
    //     continue;
    //   }

    //   // if (!isValiable(buffer.toBytes())) {
    //   //   buffer.clear();
    //   //   continue;
    //   // }

    //   logger.i('${buffer.toBytes()}');

    //   buffer.clear();

    //   buffer.addByte(byte);
    // }
  }
}
