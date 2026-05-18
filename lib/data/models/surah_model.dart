import 'package:hive/hive.dart';
import '../../domain/entities/surah.dart';

part 'surah_model.g.dart';

@HiveType(typeId: 0)
class SurahModel extends Surah {
  @override
  @HiveField(0)
  final int nomor;
  @override
  @HiveField(1)
  final String nama;
  @override
  @HiveField(2)
  final String namaLatin;
  @override
  @HiveField(3)
  final int jumlahAyat;
  @override
  @HiveField(4)
  final String tempatTurun;
  @override
  @HiveField(5)
  final String arti;
  @override
  @HiveField(6)
  final String deskripsi;
  @override
  @HiveField(7)
  final String audioFull;

  const SurahModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  }) : super(
          nomor: nomor,
          nama: nama,
          namaLatin: namaLatin,
          jumlahAyat: jumlahAyat,
          tempatTurun: tempatTurun,
          arti: arti,
          deskripsi: deskripsi,
          audioFull: audioFull,
        );

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempatTurun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audioFull: (json['audioFull'] != null && json['audioFull'] is Map) 
          ? json['audioFull']['01'] ?? '' 
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audioFull': {'01': audioFull},
    };
  }
}
