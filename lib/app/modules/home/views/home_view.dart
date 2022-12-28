import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multiparingbase/app/data/enums.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';
import 'package:multiparingbase/app/widgets/analog_tile.dart';
import 'package:multiparingbase/app/widgets/app_drawer.dart';
import 'package:multiparingbase/app/widgets/bluetooth_discovery.dart';
import 'package:multiparingbase/app/widgets/custom_floating_action_button.dart';
import 'package:multiparingbase/app/widgets/imu_tile.dart';
import 'package:multiparingbase/app/widgets/strain_gauge_tile.dart';

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
          GetBuilder<HomeController>(
            id: 'bluetoothIcon',
            builder: (_) => IconButton(
              onPressed: controller.recordState == RecordStates.none
                  ? () => Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: BluetoothDiscovery(onTap: _.connectBluetoothDevice),
                        ),
                      )
                  : null,
              icon: const Icon(Icons.bluetooth_searching),
            ),
          ),
        ],
      ),
      drawer: const CustomAppDrawer(),
      body: GetBuilder<HomeController>(
        id: 'deviceList',
        builder: (_) => ListView.builder(
          itemCount: _.devices.length,
          itemBuilder: (context, index) {
            if (_.devices[index] is Imu) {
              Imu sensor = _.devices[index] as Imu;

              return GetBuilder<HomeController>(
                id: 'tile',
                builder: (_) => ImuTile(
                  sensor: sensor,
                  signal: _.datas[index].map((e) => e as ImuSignal).toList(),
                ),
              );
            } else if (_.devices[index] is Analog) {
              Analog sensor = _.devices[index] as Analog;

              return GetBuilder<HomeController>(
                id: 'tile',
                builder: (_) => AnalogTile(
                  sensor: sensor,
                  signal: _.datas[index].map((e) => e as AnalogSignal).toList(),
                ),
              );
            } else if (_.devices[index] is StrainGauge) {
              StrainGauge sensor = _.devices[index] as StrainGauge;

              return GetBuilder<HomeController>(
                id: 'tile',
                builder: (_) => StrainGaugeTile(
                  sensor: sensor,
                  signal: _.datas[index].map((e) => e as StrainGaugeSignal).toList(),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: GetBuilder<HomeController>(
        id: 'fab',
        builder: (_) => CustomFloatingActionButton(
          state: _.recordState,
          onPressed: _.switchRecordState,
        ),
      ),
    );
  }
}
