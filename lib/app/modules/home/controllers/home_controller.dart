import 'dart:async';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart' as log;
import 'package:multiparingbase/app/data/collections/collections.dart';
import 'package:multiparingbase/app/data/enums.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';
import 'package:multiparingbase/app/data/utils.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find<HomeController>();

  final bufferLength = 400;
  final devices = <SensorBase>[];
  final datas = <RxList<SignalBase>>[];
  final log.Logger logger = log.Logger();

  RecordStates recordState = RecordStates.none;
  late Isar isar;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();

    isar = Isar.openSync([SensorInformationSchema, SensorSignalSchema]);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (devices.isNotEmpty) update(['tile']);
    });
  }

  @override
  void onClose() {
    super.onClose();

    if (isar.isOpen) isar.close();

    if (_timer.isActive) _timer.cancel();

    for (SensorBase device in devices) {
      device.disconnect();
    }
  }

  void connectBluetoothDevice(SensorType type, BluetoothDevice device) async {
    Get.back();

    Get.defaultDialog(
      title: '연결 중',
      content: const CircularProgressIndicator(),
      barrierDismissible: false,
    );

    late SensorBase sensor;

    if (type == SensorType.imu) {
      sensor = Imu(
        device: device,
        onData: onData,
        dispose: onDispose,
      );
    }
    if (type == SensorType.analog) {
      sensor = Analog(
        device: device,
        onData: onData,
        dispose: onDispose,
      );
    }
    if (type == SensorType.strainGauge) {
      sensor = StrainGauge(
        device: device,
        onData: onData,
        dispose: onDispose,
      );
    }

    if (await sensor.connect()) {
      Get.back();
      devices.add(sensor);
      datas.add(RxList());

      update(['deviceList']);
    } else {
      Get.back();

      Get.defaultDialog(
        title: '연결 실패',
        content: const Icon(
          Icons.error_outline,
          size: 40,
          color: Colors.red,
        ),
      );

      Future.delayed(const Duration(seconds: 3), Get.back);
    }
  }

  void onData(sensor, signal) async {
    int index = devices.indexOf(sensor);

    if (index == -1) return;

    datas[index].add(signal);
    if (datas[index].length > bufferLength) {
      datas[index].removeAt(0);
    }

    if (recordState == RecordStates.recording) {
      isar.writeTxnSync(() {
        isar.sensorSignals.putSync(SensorSignal(sensorId: sensor.hashCode, signals: signal.toList()));
      });
    }
  }

  void onDispose(sensor) {
    removeDevice(sensor);
  }

  Future<bool> allDispose() async {
    for (SensorBase device in devices) {
      removeDevice(device);
    }

    return true;
  }

  void removeDevice(SensorBase sensor) {
    int index = devices.indexOf(sensor);

    if (index == -1) return;

    try {
      devices.removeAt(index);
      datas.removeAt(index);

      update(['deviceList']);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void recordStart() {
    for (SensorBase device in devices) {
      device.start();
    }
  }

  void recordStop() {
    for (SensorBase device in devices) {
      device.stop();
    }
  }

  void switchRecordState(RecordStates value) async {
    recordState = value;

    update(['fab', 'bluetoothIcon']);

    if (recordState == RecordStates.recording) {
      isar.writeTxnSync(() {
        isar.sensorSignals.clearSync();
        isar.sensorInformations.clearSync();
        for (SensorBase device in devices) {
          if (device is Imu) {
            isar.sensorInformations.putSync(SensorInformation(
              id: device.hashCode,
              deviceName: device.device.name,
              type: SensorType.imu,
              units: device.contents?.units(device.unit) ?? [],
              names: device.contents?.names,
            ));
          }
          if (device is Analog) {
            isar.sensorInformations.putSync(SensorInformation(
              id: device.hashCode,
              deviceName: device.device.name,
              type: SensorType.analog,
              units: ['s', device.unit],
              names: ['time', device.unit],
            ));
          }
          if (device is StrainGauge) {
            isar.sensorInformations.putSync(SensorInformation(
              id: device.hashCode,
              deviceName: device.device.name,
              type: SensorType.strainGauge,
              units: ['s', device.unit],
              names: ['time', device.unit],
            ));
          }
        }
      });

      recordStart();
    } else if (recordState == RecordStates.none) {
      recordStop();

      await Get.defaultDialog(
        title: '계측 종료',
        content: const Text('저장하시겠습니까?'),
        textConfirm: 'CSV로 저장',
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back(result: true);
          Uint8List? bytes = await compute(Utils.toCSV, devices.length);

          if (bytes == null) return;

          DateTime now = DateTime.now();
          String formattedData = DateFormat('yyyyMMddHHmmss').format(now);
          MimeType type = MimeType.CSV;
          await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
        },
        onCancel: () => Get.back(result: false),
        textCancel: '취소',
      );
    }
  }
}
