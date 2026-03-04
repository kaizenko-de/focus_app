// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      moodIndex: fields[2] as int,
      gratitude: fields[3] as String,
      wins: (fields[4] as List).cast<Win>(),
      affirmation: fields[5] as String,
      routineIds: (fields[6] as List).cast<String>(),
      supplementIds: (fields[7] as List).cast<String>(),
      notes: fields[8] as String,
      createdAt: fields[9] as DateTime,
      isSubmitted: fields[10] as bool,
      isPerfectDay: fields[11] as bool,
      eodDate: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.moodIndex)
      ..writeByte(3)
      ..write(obj.gratitude)
      ..writeByte(4)
      ..write(obj.wins)
      ..writeByte(5)
      ..write(obj.affirmation)
      ..writeByte(6)
      ..write(obj.routineIds)
      ..writeByte(7)
      ..write(obj.supplementIds)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.isSubmitted)
      ..writeByte(11)
      ..write(obj.isPerfectDay)
      ..writeByte(12)
      ..write(obj.eodDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WinAdapter extends TypeAdapter<Win> {
  @override
  final int typeId = 1;

  @override
  Win read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Win(
      id: fields[0] as String,
      text: fields[1] as String,
      isHighlighted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Win obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isHighlighted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
