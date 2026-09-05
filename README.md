# Cek Saldo E-Money

Skeleton project Flutter + GetX untuk aplikasi cek saldo e-money via NFC.

## Struktur

```
lib/
├── main.dart                        # entry point, init Hive, GetMaterialApp
├── core/nfc/
│   ├── card_reader_strategy.dart    # interface CardReaderStrategy + NfcTagData
│   ├── mifare_classic_reader_base.dart  # base class untuk kartu MIFARE Classic
│   ├── nfc_service.dart             # orchestrator: coba tiap strategy, auto-detect
│   └── readers/
│       ├── flazz_reader.dart
│       ├── brizzi_reader.dart
│       ├── tapcash_reader.dart
│       ├── mandiri_reader.dart      # <- isi sector/key ini duluan, kamu punya kartu fisiknya
│       ├── megacash_reader.dart
│       └── kmt_reader.dart          # beda base (Ultralight, bukan Classic)
├── data/
│   ├── models/card_history_entry.dart   # Hive model riwayat scan
│   └── repositories/card_repository.dart # satu-satunya akses ke Hive box
└── app/
    ├── modules/{home,scan}/         # controller, binding, view per fitur (GetX pattern)
    └── routes/                      # app_routes.dart & app_pages.dart
```

## Yang masih perlu diisi (TODO utama)

1. **Sector index & authentication key** tiap kartu di `core/nfc/readers/*.dart`
   — nilai `targetSector` dan `authKey` sekarang masih placeholder `0` dan
   key kosong. Ini harus diisi dari hasil riset/reverse-engineering, mulai
   dari **Mandiri e-money** karena kamu sudah punya kartu fisiknya untuk
   testing. Gunakan tool seperti NFC TagInfo (Android) untuk baca raw
   dump kartu dulu sebelum coding parsing-nya.

2. **Implementasi nyata MIFARE authentication** di
   `mifare_classic_reader_base.dart` method `authenticateAndReadSector` —
   saat ini masih `throw UnimplementedError`. Perlu dipanggil lewat API
   `MifareClassic` dari package `nfc_manager`.

3. **iOS Core NFC limitation** — MIFARE Classic authentication TIDAK
   didukung native di iOS. Kemungkinan besar Flazz/Brizzi/Tapcash/
   Mandiri/Megacash **tidak bisa dibaca di iOS** dengan pendekatan ini.
   Test satu-satu dulu sebelum janji full parity Android/iOS ke user.

4. **Modul History** (`app/modules/history/`) — folder sudah ada tapi
   controller/binding/view belum dibuat. Polanya sama persis seperti
   Home & Scan: `CardRepository.getEntriesForCard(cardUid)` untuk data,
   lalu `renameCard()` untuk fitur ubah nickname.

5. Jalankan `flutter pub get` lalu kalau ada perubahan field di
   `CardHistoryEntry`, hapus `card_history_entry.g.dart` dan generate
   ulang lewat:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   (adapter saat ini ditulis manual sebagai starting point).

## Menjalankan project

```
flutter pub get
flutter run
```
