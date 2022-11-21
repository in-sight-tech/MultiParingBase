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
import 'package:multiparingbase/app/data/models/strain_gauge.dart';
import 'package:multiparingbase/app/data/utils.dart';
import 'package:multiparingbase/app/widgets/bluetooth_discovery.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final bufferLength = 400;
  final devices = RxList<Sensor>();
  final datas = <RxList<List<double?>>>[];
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

    for (Sensor device in devices) {
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

            late Sensor sensor;

            if (type == SensorType.bwt901cl) {
              sensor = IMU(
                device: device,
                onData: (IMU sensor, List<double?> data) async {
                  int index = devices.indexOf(sensor);

                  datas[index].removeAt(0);
                  datas[index].add(data);

                  if (recordState.value == true) {
                    isar.writeTxnSync(() {
                      isar.sensorSignals.putSync(SensorSignal(sensorId: sensor.device.address, signals: data));
                    });
                  }
                },
                disConnect: (IMU sensor) {
                  removeDevice(sensor);
                },
              );
            } else if (type == SensorType.strainGauge) {
              sensor = StrainGauge();
            }

            if (await sensor.connect()) {
              Get.back();
              devices.add(sensor);
              datas.add(RxList.generate(bufferLength, (index) => <double?>[null, null, null, null, null, null, null, null, null]));
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
          },
        ),
      ),
    );
  }

  void disconnect(Sensor sensor) {
    sensor.dispose();
  }

  void removeDevice(Sensor sensor) {
    int index = devices.indexOf(sensor);

    try {
      devices.remove(sensor);
      datas.removeAt(index);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void recordStart() {
    for (Sensor device in devices) {
      device.start();
    }
  }

  void setUnit(IMU sensor, String unit) {
    sensor.setUnit(unit);
  }

  void setReturnRate(IMU sensor, int frequency) {
    sensor.setReturnRate(frequency);
  }

  void calibrate(IMU sensor) {
    sensor.calibrate();
  }

  void setReturnContents(IMU sensor, ReturnContents returnContents) {
    sensor.setReturnContent(returnContents);
  }

  void switchRecordState(bool? value) async {
    if (value == null) {
      recordState.value = true;
      recordStart();
    } else if (value == true) {
      recordState.value = false;
    } else if (value == false) {
      recordState.value = null;

      Uint8List? bytes = await compute(Utils.convertCSV, devices.length);

      isar.writeTxn(() => isar.sensorSignals.clear());

      if (bytes == null) return;

      DateTime now = DateTime.now();
      String formattedData = DateFormat('yyyyMMddHHmmss').format(now);
      MimeType type = MimeType.CSV;
      await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
    }
  }
}
