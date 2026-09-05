import 'package:hive_flutter/hive_flutter.dart';

import '../models/card_history_entry.dart';

/// Satu-satunya pintu akses ke Hive box riwayat kartu. Controller/GetX
/// tidak boleh sentuh Hive langsung — selalu lewat repository ini,
/// supaya kalau nanti pindah storage (mis. ke sqflite) cukup ganti
/// implementasi di sini saja.
class CardRepository {
  static const _boxName = 'card_history';

  Box<CardHistoryEntry>? _box;

  Future<void> init() async {
    Hive.registerAdapter(CardHistoryEntryAdapter());
    _box = await Hive.openBox<CardHistoryEntry>(_boxName);
  }

  Box<CardHistoryEntry> get _requireBox {
    final box = _box;
    if (box == null) {
      throw StateError('CardRepository belum di-init(). Panggil init() dulu di main().');
    }
    return box;
  }

  /// Simpan hasil scan baru. Selalu insert entri baru (bukan overwrite),
  /// supaya riwayat balance historis per kartu tetap ada.
  Future<void> saveEntry(CardHistoryEntry entry) async {
    await _requireBox.add(entry);
  }

  /// Semua entri, terbaru duluan.
  List<CardHistoryEntry> getAllEntries() {
    final entries = _requireBox.values.toList();
    entries.sort((a, b) => b.readAt.compareTo(a.readAt));
    return entries;
  }

  /// Satu entri terbaru per cardUid — dipakai untuk list "kartu
  /// tersimpan" di halaman home.
  List<CardHistoryEntry> getLatestPerCard() {
    final all = getAllEntries(); // sudah terurut terbaru dulu
    final seen = <String>{};
    final latest = <CardHistoryEntry>[];
    for (final entry in all) {
      if (seen.add(entry.cardUid)) {
        latest.add(entry);
      }
    }
    return latest;
  }

  /// Semua entri untuk satu kartu spesifik, terbaru duluan.
  List<CardHistoryEntry> getEntriesForCard(String cardUid) {
    return getAllEntries().where((e) => e.cardUid == cardUid).toList();
  }

  /// Update nickname untuk semua entri kartu tsb (supaya konsisten
  /// dimanapun ditampilkan, tanpa perlu tabel kartu terpisah).
  Future<void> renameCard(String cardUid, String newNickname) async {
    final box = _requireBox;
    for (final entry in box.values) {
      if (entry.cardUid == cardUid) {
        entry.nickname = newNickname;
        await entry.save();
      }
    }
  }

  Future<void> deleteEntry(CardHistoryEntry entry) async {
    await entry.delete();
  }

  Future<void> deleteAllForCard(String cardUid) async {
    final toDelete = _requireBox.values.where((e) => e.cardUid == cardUid).toList();
    for (final entry in toDelete) {
      await entry.delete();
    }
  }
}
