import 'package:get/get.dart';

import '../../../../data/repositories/card_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // CardRepository di-register sebagai permanent singleton di main.dart
    // (lihat initialBinding), jadi di sini cukup Get.find().
    Get.lazyPut<HomeController>(() => HomeController(Get.find<CardRepository>()));
  }
}
