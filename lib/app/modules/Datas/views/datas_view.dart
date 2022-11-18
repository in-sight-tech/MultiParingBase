import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multiparingbase/app/widgets/app_drawer.dart';

import '../controllers/datas_controller.dart';

class DatasView extends GetView<DatasController> {
  const DatasView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DatasView'),
        centerTitle: true,
      ),
      drawer: const CustomAppDrawer(),
      body: Center(
        child: Text(
          'DatasView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
