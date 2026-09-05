import 'card_reader_strategy.dart';

/// Base class untuk kartu-kartu yang berjalan di atas chip MIFARE Classic
/// 1K/4K (Flazz, Brizzi, Tapcash, Mandiri e-money, Megacash pada dasarnya
/// semua pakai chip yang sama, bedanya cuma di sektor mana saldo disimpan
/// & key authentication yang dipakai penerbit).
///
/// Subclass tinggal isi [targetSector], [keyA]/[keyB], dan cara parsing
/// byte saldo lewat [parseBalance] — logika baca sektor & auth di-share
/// di sini supaya reader baru gampang ditambahkan.
abstract class MifareClassicReaderBase implements CardReaderStrategy {
  /// Sektor tempat data saldo disimpan. Berbeda per penerbit kartu.
  int get targetSector;

  /// Authentication key (6 byte) untuk sektor tersebut. Biasanya key A.
  /// TODO: isi dari hasil riset/reverse-engineering, JANGAN commit key
  /// asli ke repo publik — simpan lewat --dart-define atau remote config.
  List<int> get authKey;

  @override
  bool matches(NfcTagData tag) {
    // MIFARE Classic 1K: SAK biasanya 0x08, 4K: SAK 0x18.
    // Ini baru filter kasar; kepastian sebenarnya baru didapat setelah
    // authentication+parsing berhasil di [read].
    return tag.sak == 0x08 || tag.sak == 0x18;
  }

  @override
  Future<CardReadResult?> read(NfcTagData tag) async {
    try {
      final sectorData = await authenticateAndReadSector(
        tag: tag,
        sector: targetSector,
        key: authKey,
      );
      if (sectorData == null) return null;

      final balance = parseBalance(sectorData);
      if (balance == null) return null;

      return CardReadResult(
        cardType: cardType,
        cardTypeLabel: cardTypeLabel,
        cardUid: tag.uid,
        balance: balance,
        readAt: DateTime.now(),
      );
    } catch (_) {
      // Authentication gagal / bukan kartu ini — biarkan NfcService
      // lanjut coba strategy lain.
      return null;
    }
  }

  /// Melakukan MIFARE authentication ke [sector] pakai [key], lalu baca
  /// blok data di dalamnya. Diimplementasikan sekali di sini lewat
  /// platform channel nfc_manager (MifareClassic API di Android;
  /// di iOS operasi setara ini pada umumnya tidak tersedia — lihat
  /// catatan di README soal keterbatasan Core NFC).
  Future<List<int>?> authenticateAndReadSector({
    required NfcTagData tag,
    required int sector,
    required List<int> key,
  }) async {
    // TODO: implementasi nyata manggil MifareClassic.get(tag).authenticateSectorWithKeyA(...)
    // dari package nfc_manager, lalu readBlock() untuk blok data di
    // dalam sektor tsb. Placeholder di sini supaya struktur project
    // sudah jalan & bisa langsung diisi.
    throw UnimplementedError(
      'Implementasikan MIFARE authentication untuk sector $sector',
    );
  }

  /// Parsing byte mentah dari blok data jadi nominal saldo (rupiah).
  /// Format encoding beda-beda per penerbit (little/big endian, offset
  /// byte, dsb) makanya jadi abstract, wajib diisi tiap subclass.
  int? parseBalance(List<int> sectorData);
}
