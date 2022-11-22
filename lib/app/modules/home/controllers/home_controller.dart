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
import 'package:multiparingbase/app/widgets/bluetooth_discovery.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final bufferLength = 400;
  final devices = RxList<SensorBase>();
  final datas = <RxList<SignalBase>>[];
  final recordState = RxnBool(null);
  late Isar isar;

  @override
  void onInit() {
    super.onInit();

    isar = Isar.openSync([SensorInformationSchema, SensorSignalSchema]);
  }

  @override
  void onClose() {
    super.onClose();

    for (SensorBase device in devices) {
      disconnect(device);
    }
  }

  void discoveryDevice() async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: BluetoothDiscovery(
          onTap: (SensorType type, BluetoothDevice device) async {
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

                  if (recordState.isTrue ?? false) {
                    isar.writeTxnSync(() {
                      isar.sensorSignals.putSync(SensorSignal(sensorId: sensor.device.address, signals: signal.toList()));
                    });
                  }
                },
                disConnect: (BWT901CL sensor) {
                  removeDevice(sensor);
                },
              );

              if (await sensor.connect()) {
                Get.back();
                devices.add(sensor);
                datas.add(RxList.generate(bufferLength, (index) => BWT901CLSignal()));
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
              sensor = StrainGauge();
            }
          },
        ),
      ),
    );
  }

  void disconnect(SensorBase sensor) {
    sensor.dispose();
  }

  void removeDevice(SensorBase sensor) {
    int index = devices.indexOf(sensor);

    try {
      devices.remove(sensor);
      datas.removeAt(index);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void recordStart() {
    for (SensorBase device in devices) {
      device.start();
    }
  }

  void setUnit(BWT901CL sensor, String unit) {
    sensor.setUnit(unit);
  }

  void setReturnRate(BWT901CL sensor, int frequency) {
    sensor.setReturnRate(frequency);
  }

  void calibrate(BWT901CL sensor) {
    sensor.calibrate();
  }

  void setReturnContents(BWT901CL sensor, ReturnContents returnContents) {
    sensor.setReturnContent(returnContents);
  }

  void switchRecordState(bool? value) async {
    if (value == null) {
      recordState.value = true;

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
          }
        }
      });

      recordStart();
    } else if (value == true) {
      recordState.value = false;
    } else if (value == false) {
      recordState.value = null;

      Uint8List? bytes = await compute(Utils.convertCSV, devices.length);

      if (bytes == null) return;

      DateTime now = DateTime.now();
      String formattedData = DateFormat('yyyyMMddHHmmss').format(now);
      MimeType type = MimeType.CSV;
      await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
    }
  }
}
