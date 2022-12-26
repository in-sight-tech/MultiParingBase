import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

class Analog extends SensorBase {
  late AnalogSignal signal;

  final Function(Analog, AnalogSignal)? onData;
  final Function(Analog)? dispose;

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

  Analog({
    required BluetoothDevice device,
    this.dispose,
    this.onData,
  }) {
    super.device = device;
    samplingRate = 100;
    tick = 1000 ~/ samplingRate;
  }

  @override
  Future<bool> connect() async {
    try {
      Logger().i('Connecting to ${device.name}...');

      await device.connect(autoConnect: false);

      device.state.listen((BluetoothDeviceState state) {
        if (state == BluetoothDeviceState.disconnected) {
          dispose?.call(this);
        }
      });

      services = await device.discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.properties.notify == true) {
            characteristic.setNotifyValue(true);
            characteristic.value.listen((List<int> packets) {
              for (int byte in packets) {
                while (buffer.length > 12) {
                  if (buffer.elementAt(0) == 0x55 && buffer.elementAt(1) == 0x55) {
                    calSignal(ByteData.view(Uint8List.fromList(buffer.toList()).buffer));
                    buffer.clear();
                  } else {
                    buffer.removeFirst();
                  }
                }
                buffer.add(byte);
              }
            });
          }
        }
      }

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  void normalMode(Uint8List packets) {
    for (int byte in packets) {
      while (buffer.length > 9) {
        if (buffer.elementAt(0) == 0x55 && buffer.elementAt(1) == 0x55) {
          calSignal(ByteData.view(Uint8List.fromList(buffer.toList()).buffer));
          buffer.clear();
        } else {
          buffer.removeFirst();
        }
      }
      buffer.add(byte);
    }
  }

  void calSignal(ByteData bytes) async {
    signal = AnalogSignal();

    biasTime ??= bytes.getInt32(4, Endian.little);
    signal.time = bytes.getInt32(4, Endian.little) - biasTime!;
    predictTime ??= signal.time!;

    signal.value = bytes.getInt16(2, Endian.little).toDouble() / 4096.0 * 3.3;

    onData?.call(this, signal);
  }

  @override
  void disconnect() {
    device.disconnect();
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
    // mode = Mode.command;
    // connection?.output.add(Uint8List.fromList("$data".codeUnits));
    // await Future.delayed(Duration(milliseconds: delayMs));
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
