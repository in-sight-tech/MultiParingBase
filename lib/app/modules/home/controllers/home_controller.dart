import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:multiparingbase/app/data/models/data_9axis.dart';
import 'package:multiparingbase/app/data/models/imu.dart';
import 'package:multiparingbase/app/data/utils.dart';
import 'package:multiparingbase/app/widgets/bluetooth_discovery.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final bufferLength = 400;
  final devices = RxList<IMU>();
  final datas = <RxList<Data9Axis>>[];

  final segmentedControlValue = 0.obs;

  final recordState = RxnBool(null);

  void setSegmentedControlValue(int? newValue) => segmentedControlValue(newValue);

  void discoveryDevice() async {
    Get.defaultDialog(
      title: 'Devices',
      content: BluetoothDiscovery(
        onTap: (BluetoothDevice device) async {
          Get.back();

          Get.defaultDialog(
            title: '연결 중',
            content: const CircularProgressIndicator(),
            barrierDismissible: false,
          );

          IMU sensor = IMU(
            device: device,
            onData: (IMU sensor, Data9Axis? data) {
              if (data == null) return;

              int index = devices.indexOf(sensor);

              datas[index].removeAt(0);
              datas[index].add(data);
            },
            disConnect: (IMU sensor) {
              removeDevice(sensor);
            },
          );

          if (await sensor.connect()) {
            Get.back();
            devices.add(sensor);
            datas.add(RxList.generate(bufferLength, (index) => Data9Axis()));
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

  void switchRecordState(bool? value) {
    if (value == null) {
      recordState.value = true;
    } else if (value == true) {
      recordState.value = false;
    } else if (value == false) {
      recordState.value = null;
    }
  }
}
