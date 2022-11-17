import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:multiparingbase/app/data/collections/data_9axis.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/strain_gauge.dart';
import 'package:multiparingbase/app/data/utils.dart';
import 'package:multiparingbase/app/widgets/bluetooth_discovery.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final bufferLength = 400;
  final devices = RxList<Sensor>();
  final datas = <RxList<Data9Axis>>[];
  final recordState = RxnBool(null);

  final List<Isar> isars = <Isar>[];

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
                onData: (IMU sensor, Data9Axis? data) async {
                  if (data == null) return;

                  int index = devices.indexOf(sensor);

                  datas[index].removeAt(0);
                  datas[index].add(data);

                  if (recordState.value == true) {
                    await isars[index].writeTxn(() async {
                      await isars[index].data9Axis.put(data);
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
              datas.add(RxList.generate(bufferLength, (index) => Data9Axis()));
              isars.add(await Isar.open([Data9AxisSchema], name: 'sensor${isars.length + 1}', inspector: true));
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

  void disconnect(IMU sensor) {
    sensor.dispose();
  }

  void removeDevice(IMU sensor) {
    int index = devices.indexOf(sensor);

    try {
      devices.remove(sensor);
      datas.removeAt(index);
    } catch (e) {
      printError(info: e.toString());
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
    } else if (value == true) {
      recordState.value = false;
    } else if (value == false) {
      recordState.value = null;

      Uint8List? bytes = await compute(Utils.convertCSV, devices.length);

      for (var isar in isars) {
        isar.writeTxn(() async => await isar.data9Axis.clear());
      }

      if (bytes == null) return;

      DateTime now = DateTime.now();
      String formattedData = DateFormat('yyyyMMddHHmmss').format(now);
      MimeType type = MimeType.CSV;
      await FileSaver.instance.saveAs('$formattedData.csv', bytes, 'csv', type);
    }
  }
}
