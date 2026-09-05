import 'package:get/get.dart';

import '../../../../data/models/card_history_entry.dart';
import '../../../../data/repositories/card_repository.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final CardRepository _repository;

  HomeController(this._repository);

  final savedCards = <CardHistoryEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCards();
  }

  /// Dipanggil lagi setiap kali kembali ke Home (mis. setelah scan baru
  /// selesai) supaya list ter-refresh tanpa perlu full app restart.
  void _loadCards() {
    savedCards.assignAll(_repository.getLatestPerCard());
  }

  void refresh() => _loadCards();

  void goToScan() async {
    await Get.toNamed(AppRoutes.scan);
    _loadCards(); // refresh begitu balik dari scan
  }

  void goToCardDetail(CardHistoryEntry card) {
    Get.toNamed(AppRoutes.history, arguments: card.cardUid);
  }
}
