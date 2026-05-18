// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TafsirModelAdapter extends TypeAdapter<TafsirModel> {
  @override
  final int typeId = 3;

  @override
  TafsirModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TafsirModel(
      ayat: fields[0] as int,
      teks: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TafsirModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ayat)
      ..writeByte(1)
      ..write(obj.teks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TafsirModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
