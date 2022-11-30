import 'dart:async';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:multiparingbase/app/data/collections/sensor_information.dart';
import 'package:multiparingbase/app/data/collections/sensor_signal.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';
import 'package:multiparingbase/app/data/utils.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find<HomeController>();

  final bufferLength = 400;
  final devices = <SensorBase>[];
  final datas = <RxList<SignalBase>>[];

  bool? recordState;
  late Isar isar;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();

    isar = Isar.openSync([SensorInformationSchema, SensorSignalSchema]);

    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (devices.isNotEmpty) update(['tile']);
    });
  }

  @override
  void onClose() {
    super.onClose();

    _timer.cancel();
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

    if (type == SensorType.bwt901cl) {
      sensor = BWT901CL(
        device: device,
        onData: (BWT901CL sensor, BWT901CLSignal signal) async {
          int index = devices.indexOf(sensor);

          datas[index].removeAt(0);
          datas[index].add(signal);

          if (recordState ?? false) {
            isar.writeTxnSync(() {
              isar.sensorSignals.putSync(SensorSignal(sensorId: sensor.device.address, signals: signal.toList()));
            });
          }
        },
        dispose: (BWT901CL sensor) {
          removeDevice(sensor);
        },
      );

      if (await sensor.connect()) {
        Get.back();
        devices.add(sensor);
        datas.add(RxList.generate(bufferLength, (index) => BWT901CLSignal()));

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
    } else if (type == SensorType.strainGauge) {
      sensor = StrainGauge(
        device: device,
        onRealTimeSignal: (StrainGauge sensor, StrainGaugeSignal signal) async {
          int index = devices.indexOf(sensor);

          datas[index].removeAt(0);
          datas[index].add(signal);
        },
        onData: (StrainGauge sensor, List<StrainGaugeSignal> signals) async {
          if (recordState ?? false) {
            isar.writeTxnSync(() {
              isar.sensorSignals.putAllSync(signals.map((e) => SensorSignal(sensorId: sensor.device.address, signals: e.toList())).toList());
            });
          }
        },
        dispose: (StrainGauge sensor) {
          removeDevice(sensor);
        },
      );

      if (await sensor.connect()) {
        Get.back();
        devices.add(sensor);
        datas.add(RxList.generate(bufferLength, (index) => StrainGaugeSignal()));

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
    } else if (type == SensorType.imu) {
    } else if (type == SensorType.analog) {}
  }

  void removeDevice(SensorBase sensor) {
    int index = devices.indexOf(sensor);

    if (index == -1) throw 'Not Found';

    try {
      devices.remove(sensor);
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

  void switchRecordState(bool? value) async {
    if (value == null) {
      recordState = true;
      update(['fab', 'bluetoothIcon']);

      isar.writeTxnSync(() {
        isar.sensorSignals.clearSync();
        isar.sensorInformations.clearSync();
      });

      isar.writeTxnSync(() {
        for (SensorBase device in devices) {
          if (device is BWT901CL) {
            isar.sensorInformations.putSync(SensorInformation(
              id: device.device.address,
              type: SensorType.bwt901cl,
              units: device.returnContents.toUnitList(device.accelerationUnit),
              names: device.returnContents.toNameList(),
            ));
          } else if (device is StrainGauge) {
            isar.sensorInformations.putSync(SensorInformation(
              id: device.device.address,
              type: SensorType.strainGauge,
              units: ['s', 'v'],
              names: ['time', 'value'],
            ));
          }
        }
      });

      recordStart();
    } else if (value == true) {
      recordState = false;
      update(['fab', 'bluetoothIcon']);
    } else if (value == false) {
      recordState = null;
      update(['fab', 'bluetoothIcon']);
      recordStop();

      Uint8List? bytes = await compute(Utils.convertCSV, devices.length);

      if (bytes == null) return;

      DateTime now = DateTime.now();
      String formattedData = DateFormat('yyyyMMddHHmmss').format(now);
      MimeType type = MimeType.CSV;
      await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
    }
  }
}
