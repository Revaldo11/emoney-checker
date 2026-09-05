import '../card_reader_strategy.dart';

/// KMT (Kartu Multi Trip commuter line) umumnya berjalan di atas chip
/// MIFARE Ultralight/Ultralight C, BUKAN MIFARE Classic — makanya reader
/// ini implement [CardReaderStrategy] langsung, tidak lewat
/// [MifareClassicReaderBase]. Alur bacanya juga beda: Ultralight tidak
/// pakai sector authentication seperti Classic, tapi baca page langsung
/// (kadang dengan password authentication tergantung varian kartu).
class KmtReader implements CardReaderStrategy {
  @override
  String get cardType => 'kmt';

  @override
  String get cardTypeLabel => 'KMT';

  @override
  bool matches(NfcTagData tag) {
    // MIFARE Ultralight biasanya SAK 0x00.
    return tag.sak == 0x00;
  }

  @override
  Future<CardReadResult?> read(NfcTagData tag) async {
    try {
      final pages = await readUltralightPages(tag);
      if (pages == null) return null;

      final balance = parseBalance(pages);
      if (balance == null) return null;

      return CardReadResult(
        cardType: cardType,
        cardTypeLabel: cardTypeLabel,
        cardUid: tag.uid,
        balance: balance,
        readAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  /// TODO: implementasi nyata pakai MifareUltralight.get(tag).readPages()
  /// dari package nfc_manager. Placeholder dulu.
  Future<List<int>?> readUltralightPages(NfcTagData tag) async {
    throw UnimplementedError('Implementasikan pembacaan page Ultralight untuk KMT');
  }

  /// TODO: sesuaikan offset page/byte tempat saldo KMT disimpan.
  int? parseBalance(List<int> pages) {
    if (pages.length < 4) return null;
    return pages[0] | (pages[1] << 8) | (pages[2] << 16) | (pages[3] << 24);
  }
}
