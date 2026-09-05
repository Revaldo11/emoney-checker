import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';

import 'card_reader_strategy.dart';
import 'readers/flazz_reader.dart';
import 'readers/brizzi_reader.dart';
import 'readers/tapcash_reader.dart';
import 'readers/mandiri_reader.dart';
import 'readers/megacash_reader.dart';
import 'readers/kmt_reader.dart';

enum NfcReadStatus { idle, waiting, reading, success, notRecognized, error }

/// Titik masuk tunggal untuk semua operasi NFC di aplikasi.
///
/// Alurnya sesuai auto-detect penuh yang sudah didiskusikan: saat kartu
/// ditap, service ini akan mencoba setiap [CardReaderStrategy] yang
/// terdaftar satu per satu (lewat [matches] dulu sebagai filter cepat,
/// baru [read] yang sebenarnya). Begitu salah satu berhasil, proses
/// berhenti dan hasil dikembalikan. Kalau semua strategy gagal, service
/// melempar [CardNotRecognizedException] supaya UI bisa tampilkan state
/// "gagal baca" tanpa user pernah perlu memilih jenis kartu secara manual.
class NfcService {
  /// Daftar strategy — urutan sedikit berpengaruh ke performa (taruh
  /// yang paling sering dipakai user duluan), tapi tidak mempengaruhi
  /// korektnes karena tiap strategy match berdasarkan karakteristik tag.
  final List<CardReaderStrategy> _strategies = [
    FlazzReader(),
    MandiriReader(),
    BrizziReader(),
    TapcashReader(),
    MegacashReader(),
    KmtReader(),
  ];

  /// Mulai satu sesi scan. Resolusi Future terjadi begitu satu tag
  /// selesai diproses (berhasil atau gagal semua strategy), lalu
  /// session otomatis di-stop.
  Future<CardReadResult> startSession() async {
    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      throw const NfcUnavailableException();
    }

    final completer = _SessionCompleter<CardReadResult>();

    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443, // MIFARE Classic & Ultralight lewat ISO14443
      },
      onDiscovered: (NfcTag tag) async {
        try {
          final tagData = _mapToTagData(tag);
          final result = await _tryAllStrategies(tagData);

          if (result != null) {
            completer.complete(result);
          } else {
            completer.completeError(const CardNotRecognizedException());
          }
        } catch (e) {
          completer.completeError(e);
        } finally {
          await NfcManager.instance.stopSession();
        }
      },
    );

    return completer.future;
  }

  Future<void> cancelSession() async {
    await NfcManager.instance.stopSession();
  }

  Future<CardReadResult?> _tryAllStrategies(NfcTagData tagData) async {
    for (final strategy in _strategies) {
      if (!strategy.matches(tagData)) continue;

      final result = await strategy.read(tagData);
      if (result != null) return result;
      // Kalau matches() true tapi read() gagal (mis. key auth salah),
      // lanjut coba strategy berikutnya — bisa saja dua jenis kartu
      // punya SAK yang sama tapi key beda.
    }
    return null;
  }

  /// Mapping dari objek NfcTag milik package nfc_manager ke [NfcTagData]
  /// yang platform-agnostic, supaya layer strategy tidak bergantung
  /// langsung ke package pihak ketiga.
  NfcTagData _mapToTagData(NfcTag tag) {
    // TODO: sesuaikan dengan API terbaru nfc_manager untuk ambil UID,
    // ATQA, SAK dari tag.data (struktur berbeda antara Android/iOS).
    final data = tag.data;
    return NfcTagData(
      uid: (data['nfca']?['identifier'] ?? data['identifier'] ?? '')
          .toString(),
      raw: data,
    );
  }
}

class NfcUnavailableException implements Exception {
  const NfcUnavailableException();
}

class CardNotRecognizedException implements Exception {
  const CardNotRecognizedException();
}

/// Helper kecil supaya `onDiscovered` callback (yang bisa terpanggil
/// berkali-kali kalau ada tag beragam di sekitar) hanya menyelesaikan
/// Future satu kali.
class _SessionCompleter<T> {
  final _completer = Completer<T>();
  bool _done = false;

  Future<T> get future => _completer.future;

  void complete(T value) {
    if (_done) return;
    _done = true;
    _completer.complete(value);
  }

  void completeError(Object error) {
    if (_done) return;
    _done = true;
    _completer.completeError(error);
  }
}
