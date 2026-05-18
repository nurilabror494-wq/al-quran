import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final String audio;

  const Ayah({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  @override
  List<Object?> get props => [
        nomorAyat,
        teksArab,
        teksLatin,
        teksIndonesia,
        audio,
      ];
}
