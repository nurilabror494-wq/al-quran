import 'package:hive/hive.dart';
import '../../domain/entities/tafsir.dart';

part 'tafsir_model.g.dart';

@HiveType(typeId: 3)
class TafsirModel extends Tafsir {
  @HiveField(0)
  final int ayat;
  @HiveField(1)
  final String teks;

  const TafsirModel({
    required this.ayat,
    required this.teks,
  }) : super(ayat: ayat, teks: teks);

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      ayat: json['ayat'] ?? 0,
      teks: json['teks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ayat': ayat,
      'teks': teks,
    };
  }
}
