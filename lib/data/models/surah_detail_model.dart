import 'package:hive/hive.dart';
import '../../domain/entities/surah_detail.dart';
import 'ayah_model.dart';

part 'surah_detail_model.g.dart';

@HiveType(typeId: 2)
class SurahDetailModel extends SurahDetail {
  @HiveField(0)
  final int nomor;
  @HiveField(1)
  final String nama;
  @HiveField(2)
  final String namaLatin;
  @HiveField(3)
  final int jumlahAyat;
  @HiveField(4)
  final String tempatTurun;
  @HiveField(5)
  final String arti;
  @HiveField(6)
  final String deskripsi;
  @HiveField(7)
  final String audioFull;
  @HiveField(8)
  final List<AyahModel> ayatModels;

  const SurahDetailModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayatModels,
  }) : super(
          nomor: nomor,
          nama: nama,
          namaLatin: namaLatin,
          jumlahAyat: jumlahAyat,
          tempatTurun: tempatTurun,
          arti: arti,
          deskripsi: deskripsi,
          audioFull: audioFull,
          ayat: ayatModels,
        );

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    return SurahDetailModel(
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
      ayatModels: (json['ayat'] as List?)
              ?.map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'ayat': ayatModels.map((e) => e.toJson()).toList(),
    };
  }
}
