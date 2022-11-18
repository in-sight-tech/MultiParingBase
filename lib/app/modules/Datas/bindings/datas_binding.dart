import 'package:get/get.dart';

import '../controllers/datas_controller.dart';

class DatasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatasController>(
      () => DatasController(),
    );
  }
}
