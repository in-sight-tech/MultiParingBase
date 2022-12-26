import 'dart:async';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
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

          if (recordState == RecordStates.recording) {
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
        onData: (StrainGauge sensor, StrainGaugeSignal signal) async {
          int index = devices.indexOf(sensor);

          datas[index].removeAt(0);
          datas[index].add(signal);

          if (recordState == RecordStates.recording) {
            isar.writeTxnSync(() {
              isar.sensorSignals.putSync(SensorSignal(sensorId: sensor.device.address, signals: signal.toList()));
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
      sensor = Imu(
        device: device,
        onData: (Imu sensor, ImuSignal signal) async {
          int index = devices.indexOf(sensor);

          datas[index].removeAt(0);
          datas[index].add(signal);

          if (recordState == RecordStates.recording) {
            isar.writeTxnSync(() {
              isar.sensorSignals.putSync(SensorSignal(sensorId: sensor.device.address, signals: signal.toList()));
            });
          }
        },
        dispose: (Imu sensor) {
          removeDevice(sensor);
        },
      );

      if (await sensor.connect()) {
        Get.back();
        devices.add(sensor);
        datas.add(RxList.generate(bufferLength, (index) => ImuSignal()));

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

  void switchRecordState(RecordStates value) async {
    recordState = value;

    update(['fab', 'bluetoothIcon']);

    if (recordState == RecordStates.recording) {
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
              units: ['s', device.unit],
              names: ['time', 'voltage'],
            ));
          }
        }
      });

      recordStart();
    } else if (recordState == RecordStates.none) {
      recordStop();

      await Get.bottomSheet(
        Container(
          width: 300,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('저장하시겠습니까?', style: TextStyle(fontSize: 25)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(result: false), child: const Text('취소')),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('App에 저장'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back(result: true);
                      Uint8List? bytes = await compute(Utils.toCSV, devices.length);

                      if (bytes == null) return;

                      DateTime now = DateTime.now();
                      String formattedData = DateFormat('yyyyMMddHHmmss').format(now);
                      MimeType type = MimeType.CSV;
                      await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
                    },
                    child: const Text('Csv로 저장'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
