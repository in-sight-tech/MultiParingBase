import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:multiparingbase/app/data/models/sensor_types/sensor_base.dart';
import 'package:multiparingbase/app/data/models/signals.dart';

/// * <record,data> 명령어를 전송 했을 경우 센서에서 <record,start> 또는 <record,fail>의 응답이 올 수있음.
/// * 센서에서 데이터를 저장할 text파일을 만들었을 경우 <record,start> 응답
/// * 센서에서 데이터를 저장할 text파일을 만들지 못했을 경우 (sd카드가 장착되지 않은 경우) <record,fail> 응답

class StrainGauge extends SensorBase {
  late StrainGaugeSignal signal;

  final Function(StrainGauge, StrainGaugeSignal)? onRealTimeSignal;
  final Function(StrainGauge, List<StrainGaugeSignal>)? onData;
  final Function(StrainGauge)? dispose;

  int? predictTime;
  int? biasTime;

  String unit = 'mm';

  Mode mode = Mode.normal;

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
    String command = String.fromCharCodes(packets);

    switch (command) {
      case '<sr>':
        break;
      case '<record,start>':
        break;
      case '<record,fail>':
        break;
      case '<record,done>':
        break;
      default:
        break;
    }

    writeReg(data: '<end>');
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

  @override
  Future<bool> setSamplingRate(int samplingRate) async {
    await writeReg(data: 'sr,$samplingRate');

    return true;
  }

  Future<void> writeReg({required dynamic data, int delayMs = 0}) async {
    mode = Mode.command;
    connection?.output.add(Uint8List.fromList("$data".codeUnits));
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  void start() => writeReg(data: '<record,${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}>');

  @override
  void stop() => writeReg(data: '<record,done>');

  void requestData() => writeReg(data: '<requestData>');
}
