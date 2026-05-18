// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AyahModelAdapter extends TypeAdapter<AyahModel> {
  @override
  final int typeId = 1;

  @override
  AyahModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AyahModel(
      nomorAyat: fields[0] as int,
      teksArab: fields[1] as String,
      teksLatin: fields[2] as String,
      teksIndonesia: fields[3] as String,
      audio: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AyahModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nomorAyat)
      ..writeByte(1)
      ..write(obj.teksArab)
      ..writeByte(2)
      ..write(obj.teksLatin)
      ..writeByte(3)
      ..write(obj.teksIndonesia)
      ..writeByte(4)
      ..write(obj.audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
