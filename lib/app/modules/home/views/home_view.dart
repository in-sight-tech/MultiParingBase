import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multiparingbase/app/data/models/models.dart';
import 'package:multiparingbase/app/data/models/signals.dart';
import 'package:multiparingbase/app/widgets/app_drawer.dart';
import 'package:multiparingbase/app/widgets/bwt901cl_setting_dialog.dart';
import 'package:multiparingbase/app/widgets/bwt901cl_tile.dart';
import 'package:multiparingbase/app/widgets/custom_floating_action_button.dart';

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
              onPressed: controller.recordState == null ? _.discoveryDevice : null,
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
            if (_.devices[index] is BWT901CL) {
              BWT901CL sensor = _.devices[index] as BWT901CL;

              return GetBuilder<HomeController>(
                id: 'chart',
                builder: (_) => BWT901CLTile(
                  sensor: sensor,
                  signal: _.datas[index].map((e) => e as BWT901CLSignal).toList(),
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
