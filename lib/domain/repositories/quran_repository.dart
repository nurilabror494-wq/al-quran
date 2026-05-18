import 'package:dartz/dartz.dart';
import '../entities/surah.dart';
import '../entities/surah_detail.dart';
import '../entities/tafsir.dart';

abstract class QuranRepository {
  Future<Either<Exception, List<Surah>>> getSurahs();
  Future<Either<Exception, SurahDetail>> getSurahDetail(int nomor);
  Future<Either<Exception, List<Tafsir>>> getTafsir(int nomor);
  Future<void> syncSurahsBackground();
}
