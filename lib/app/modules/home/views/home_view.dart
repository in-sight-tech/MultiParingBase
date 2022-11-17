import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/widgets/imu_setting_dialog.dart';
import 'package:multiparingbase/app/widgets/imu_tile.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
                onPressed: controller.recordState.value == null ? controller.discoveryDevice : null,
                icon: const Icon(Icons.bluetooth_searching),
              )),
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.devices.length,
            itemBuilder: (context, index) {
              IMU sensor = controller.devices[index] as IMU;

              return Obx(() => IMUTile(
                    title: sensor.device.name ?? '',
                    unit: sensor.accelerationUnit,
                    onSetting: () => Get.defaultDialog(
                      title: sensor.device.name ?? '',
                      content: IMUSettingDialog(
                        unit: sensor.accelerationUnit,
                        setUnit: (String unit) => controller.setUnit(sensor, unit),
                        returnRate: sensor.frequency,
                        setReturnRate: (int frequency) => controller.setReturnRate(sensor, frequency),
                        calibrate: () => controller.calibrate(sensor),
                        returnContents: sensor.returnContents,
                        setReturnContents: (ReturnContents returnContents) => controller.setReturnContents(sensor, returnContents),
                      ),
                    ),
                    onClose: () => controller.disconnect(sensor),
                    // ignore: invalid_use_of_protected_member
                    signal: controller.datas[index].value,
                  ));
            },
          )),
      floatingActionButton: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (controller.recordState.value == null)
                FloatingActionButton(
                  onPressed: () => controller.switchRecordState(null),
                  child: const Icon(Icons.play_arrow_rounded),
                ),
              if (controller.recordState.value == true)
                FloatingActionButton(
                  onPressed: () => controller.switchRecordState(true),
                  child: const Icon(Icons.pause_rounded),
                ),
              if (controller.recordState.value == false)
                FloatingActionButton(
                  onPressed: () => controller.switchRecordState(null),
                  child: const Icon(Icons.play_arrow_rounded),
                ),
              if (controller.recordState.value == false) const SizedBox(width: 10),
              if (controller.recordState.value == false)
                FloatingActionButton(
                  onPressed: () => controller.switchRecordState(false),
                  child: const Icon(Icons.stop_rounded),
                ),
            ],
          )),
    );
  }
}
