import 'package:hive/hive.dart';

part 'card_history_entry.g.dart';

/// Satu entri riwayat hasil scan. Disimpan flat (bukan nested per kartu)
/// supaya query "riwayat semua kartu" dan "riwayat 1 kartu tertentu"
/// sama-sama gampang — filter cukup by [cardUid].
@HiveType(typeId: 0)
class CardHistoryEntry extends HiveObject {
  @HiveField(0)
  final String cardUid;

  @HiveField(1)
  final String cardType; // 'flazz', 'brizzi', dst — key stabil, bukan label

  @HiveField(2)
  final String cardTypeLabel; // 'Flazz' — untuk ditampilkan

  @HiveField(3)
  final int balance;

  @HiveField(4)
  final DateTime readAt;

  @HiveField(5)
  String? nickname; // diisi user manual, mutable makanya bukan final

  CardHistoryEntry({
    required this.cardUid,
    required this.cardType,
    required this.cardTypeLabel,
    required this.balance,
    required this.readAt,
    this.nickname,
  });

  /// Nama yang ditampilkan di UI: pakai nickname kalau sudah diset,
  /// fallback ke label jenis kartu + 4 digit terakhir UID.
  String get displayName {
    if (nickname != null && nickname!.trim().isNotEmpty) return nickname!;
    final shortUid = cardUid.length >= 4
        ? cardUid.substring(cardUid.length - 4)
        : cardUid;
    return '$cardTypeLabel •••• $shortUid';
  }
}
