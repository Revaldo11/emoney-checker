import 'package:get/get.dart';

import '../../../../core/nfc/nfc_service.dart';
import '../../../../data/repositories/card_repository.dart';
import '../controllers/scan_controller.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(
      () => ScanController(
        NfcService(),
        Get.find<CardRepository>(),
      ),
    );
  }
}
