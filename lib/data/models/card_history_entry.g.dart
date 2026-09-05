part of 'card_history_entry.dart';

// Adapter ini ditulis manual sebagai starting point. Kalau nanti nambah
// field baru di CardHistoryEntry, lebih aman hapus file ini dan jalankan:
//   flutter pub run build_runner build --delete-conflicting-outputs
// supaya adapter ter-generate otomatis dan konsisten.
class CardHistoryEntryAdapter extends TypeAdapter<CardHistoryEntry> {
  @override
  final int typeId = 0;

  @override
  CardHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardHistoryEntry(
      cardUid: fields[0] as String,
      cardType: fields[1] as String,
      cardTypeLabel: fields[2] as String,
      balance: fields[3] as int,
      readAt: fields[4] as DateTime,
      nickname: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CardHistoryEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.cardUid)
      ..writeByte(1)
      ..write(obj.cardType)
      ..writeByte(2)
      ..write(obj.cardTypeLabel)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.readAt)
      ..writeByte(5)
      ..write(obj.nickname);
  }
}
