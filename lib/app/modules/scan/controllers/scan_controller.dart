import 'package:get/get.dart';

import '../../../../core/nfc/card_reader_strategy.dart';
import '../../../../core/nfc/nfc_service.dart';
import '../../../../data/models/card_history_entry.dart';
import '../../../../data/repositories/card_repository.dart';
import '../../../routes/app_routes.dart';

enum ScanUiState { waiting, reading, success, notRecognized, error }

class ScanController extends GetxController {
  final NfcService _nfcService;
  final CardRepository _repository;

  ScanController(this._nfcService, this._repository);

  final uiState = ScanUiState.waiting.obs;
  final Rxn<CardReadResult> lastResult = Rxn<CardReadResult>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    startScan();
  }

  Future<void> startScan() async {
    uiState.value = ScanUiState.waiting;
    errorMessage.value = '';

    try {
      final result = await _nfcService.startSession();
      uiState.value = ScanUiState.success;
      lastResult.value = result;
      await _saveToHistory(result);
    } on NfcUnavailableException {
      uiState.value = ScanUiState.error;
      errorMessage.value = 'NFC tidak aktif. Aktifkan NFC di pengaturan HP kamu.';
    } on CardNotRecognizedException {
      uiState.value = ScanUiState.notRecognized;
    } catch (_) {
      uiState.value = ScanUiState.error;
      errorMessage.value = 'Terjadi kesalahan saat membaca kartu.';
    }
  }

  Future<void> _saveToHistory(CardReadResult result) async {
    await _repository.saveEntry(
      CardHistoryEntry(
        cardUid: result.cardUid,
        cardType: result.cardType,
        cardTypeLabel: result.cardTypeLabel,
        balance: result.balance,
        readAt: result.readAt,
      ),
    );
  }

  void retry() => startScan();

  void goBackToHome() => Get.offAllNamed(AppRoutes.home);

  @override
  void onClose() {
    _nfcService.cancelSession();
    super.onClose();
  }
}
