import '../mifare_classic_reader_base.dart';

class BrizziReader extends MifareClassicReaderBase {
  @override
  String get cardType => 'brizzi';

  @override
  String get cardTypeLabel => 'Brizzi';

  // TODO: ganti dengan sector index & key hasil riset untuk Brizzi.
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
