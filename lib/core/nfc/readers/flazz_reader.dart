import '../mifare_classic_reader_base.dart';

class FlazzReader extends MifareClassicReaderBase {
  @override
  String get cardType => 'flazz';

  @override
  String get cardTypeLabel => 'Flazz';

  // TODO: ganti dengan sector index & key hasil riset untuk Flazz.
  @override
  int get targetSector => 0;

  @override
  List<int> get authKey => const [0, 0, 0, 0, 0, 0];

  @override
  int? parseBalance(List<int> sectorData) {
    // TODO: sesuaikan offset & endianness sesuai hasil riset.
    // Placeholder: asumsikan saldo di 4 byte pertama, little-endian.
    if (sectorData.length < 4) return null;
    return sectorData[0] |
        (sectorData[1] << 8) |
        (sectorData[2] << 16) |
        (sectorData[3] << 24);
  }
}
