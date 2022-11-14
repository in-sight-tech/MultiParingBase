import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multiparingbase/app/data/models/imu.dart';
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
          IconButton(
            onPressed: controller.discoveryDevice,
            icon: const Icon(Icons.bluetooth_searching),
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.devices.length,
            itemBuilder: (context, index) {
              return Obx(() => IMUTile(
                    title: controller.devices[index].device.name ?? '',
                    unit: controller.devices[index].unit,
                    onSetting: () => Get.defaultDialog(
                      title: controller.devices[index].device.name ?? '',
                      content: IMUSettingDialog(
                        unit: controller.devices[index].unit,
                        setUnit: (String unit) => controller.setUnit(controller.devices[index], unit),
                        returnRate: controller.devices[index].frequency,
                        setReturnRate: (int frequency) => controller.setReturnRate(controller.devices[index], frequency),
                        calibrate: () => controller.calibrate(controller.devices[index]),
                        returnContents: controller.devices[index].returnContents,
                        setReturnContents: (ReturnContents returnContents) => controller.setReturnContents(controller.devices[index], returnContents),
                      ),
                    ),
                    onClose: () => controller.disconnect(controller.devices[index]),
                    // ignore: invalid_use_of_protected_member
                    signal: controller.datas[index].value,
                  ));
            },
          )),
    );
  }
}
