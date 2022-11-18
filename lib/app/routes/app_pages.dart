import 'package:get/get.dart';

import '../modules/Datas/bindings/datas_binding.dart';
import '../modules/Datas/views/datas_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DATAS,
      page: () => const DatasView(),
      binding: DatasBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
