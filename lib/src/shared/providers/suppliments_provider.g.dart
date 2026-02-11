// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suppliments_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplementAdapter extends TypeAdapter<Supplement> {
  @override
  final int typeId = 2;

  @override
  Supplement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Supplement(
      id: fields[0] as String,
      name: fields[1] as String,
      dosage: fields[2] as String,
      timeOfDay: fields[3] as String,
      frequency: fields[4] as String,
      reminderEnabled: fields[5] as bool,
      icon: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Supplement obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dosage)
      ..writeByte(3)
      ..write(obj.timeOfDay)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.reminderEnabled)
      ..writeByte(6)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
