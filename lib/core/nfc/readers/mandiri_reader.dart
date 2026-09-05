import '../mifare_classic_reader_base.dart';

class MandiriReader extends MifareClassicReaderBase {
  @override
  String get cardType => 'mandiri_emoney';

  @override
  String get cardTypeLabel => 'Mandiri e-money';

  // Sector & key ini paling penting untuk divalidasi lebih dulu karena
  // kamu sudah punya kartu fisik Mandiri untuk testing.
  // TODO: isi berdasarkan hasil trial dengan NFC TagInfo / riset lain.
  @override
  int get targetSector => 0;

  @override
  List<int> get authKey => const [0, 0, 0, 0, 0, 0];

  @override
  int? parseBalance(List<int> sectorData) {
    if (sectorData.length < 4) return null;
    return sectorData[0] |
        (sectorData[1] << 8) |
        (sectorData[2] << 16) |
        (sectorData[3] << 24);
  }
}
