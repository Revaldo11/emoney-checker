/// Hasil pembacaan kartu, dikembalikan oleh setiap [CardReaderStrategy]
/// yang berhasil mengenali & membaca kartu.
class CardReadResult {
  final String cardType; // 'flazz', 'brizzi', 'tapcash', dst
  final String cardTypeLabel; // 'Flazz', 'Brizzi', dst — untuk ditampilkan
  final String cardUid; // UID fisik kartu, dipakai sebagai key riwayat
  final int balance; // dalam rupiah, bulat
  final DateTime readAt;

  const CardReadResult({
    required this.cardType,
    required this.cardTypeLabel,
    required this.cardUid,
    required this.balance,
    required this.readAt,
  });
}

/// Setiap jenis kartu (Flazz, Brizzi, Tapcash, Mandiri, Megacash, KMT)
/// diimplementasikan sebagai satu strategy. [NfcService] akan mencoba
/// setiap strategy yang terdaftar secara berurutan sampai salah satu
/// berhasil membaca kartu.
///
/// PENTING: struktur sektor & authentication key di bawah ini BUKAN API
/// resmi dari bank/operator kartu. Nilai-nilai ini didapat dari riset
/// mandiri/reverse-engineering dan bisa berubah sewaktu-waktu kalau
/// penerbit kartu mengubah struktur datanya. Selalu tambahkan fallback
/// & pesan error yang jelas ke pengguna.
abstract class CardReaderStrategy {
  /// Identifier singkat, dipakai sebagai key penyimpanan & analytics.
  String get cardType;

  /// Label untuk ditampilkan di UI, mis. "Flazz".
  String get cardTypeLabel;

  /// Dipanggil oleh [NfcService] dengan raw tag data (dependency-agnostic,
  /// lihat [NfcTagData]). Return true kalau tag ini "kelihatannya" cocok
  /// dengan jenis kartu ini (mis. berdasarkan ATQA/SAK/ukuran memori),
  /// sebelum mencoba proses baca yang lebih berat (authentication dsb).
  bool matches(NfcTagData tag);

  /// Coba baca saldo dari tag. Return null kalau ternyata gagal meski
  /// [matches] tadinya true (mis. authentication key salah / data corrupt)
  /// — [NfcService] akan lanjut mencoba strategy berikutnya.
  Future<CardReadResult?> read(NfcTagData tag);
}

/// Wrapper platform-agnostic di atas data tag NFC mentah, supaya layer
/// core/nfc tidak terikat langsung ke package nfc_manager. Isi field ini
/// diisi oleh [NfcService] dari hasil `nfc_manager` saat tag terdeteksi.
class NfcTagData {
  final String uid; // hex string, mis. "04A1B2C3"
  final int? atqa;
  final int? sak;
  final Map<String, dynamic> raw; // data platform-spesifik kalau dibutuhkan

  const NfcTagData({
    required this.uid,
    this.atqa,
    this.sak,
    this.raw = const {},
  });
}
