// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahDetailModelAdapter extends TypeAdapter<SurahDetailModel> {
  @override
  final int typeId = 2;

  @override
  SurahDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahDetailModel(
      nomor: fields[0] as int,
      nama: fields[1] as String,
      namaLatin: fields[2] as String,
      jumlahAyat: fields[3] as int,
      tempatTurun: fields[4] as String,
      arti: fields[5] as String,
      deskripsi: fields[6] as String,
      audioFull: fields[7] as String,
      ayatModels: (fields[8] as List).cast<AyahModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SurahDetailModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.nomor)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.namaLatin)
      ..writeByte(3)
      ..write(obj.jumlahAyat)
      ..writeByte(4)
      ..write(obj.tempatTurun)
      ..writeByte(5)
      ..write(obj.arti)
      ..writeByte(6)
      ..write(obj.deskripsi)
      ..writeByte(7)
      ..write(obj.audioFull)
      ..writeByte(8)
      ..write(obj.ayatModels);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
