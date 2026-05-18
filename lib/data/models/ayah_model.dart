import 'package:hive/hive.dart';
import '../../domain/entities/ayah.dart';

part 'ayah_model.g.dart';

@HiveType(typeId: 1)
class AyahModel extends Ayah {
  @override
  @HiveField(0)
  final int nomorAyat;
  @override
  @HiveField(1)
  final String teksArab;
  @override
  @HiveField(2)
  final String teksLatin;
  @override
  @HiveField(3)
  final String teksIndonesia;
  @override
  @HiveField(4)
  final String audio;

  const AyahModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  }) : super(
          nomorAyat: nomorAyat,
          teksArab: teksArab,
          teksLatin: teksLatin,
          teksIndonesia: teksIndonesia,
          audio: audio,
        );

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
      audio: (json['audio'] != null && json['audio'] is Map) 
          ? json['audio']['01'] ?? '' 
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomorAyat': nomorAyat,
      'teksArab': teksArab,
      'teksLatin': teksLatin,
      'teksIndonesia': teksIndonesia,
      'audio': {'01': audio},
    };
  }
}
