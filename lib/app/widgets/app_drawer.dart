import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Insight:tech'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Get.offNamed('/home');
            },
          ),
          ListTile(
            title: const Text('Datas'),
            onTap: () {
              Get.offNamed('/datas');
            },
          ),
        ],
      ),
    );
  }
}
