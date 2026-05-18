import 'package:dartz/dartz.dart';
import '../entities/surah.dart';
import '../entities/surah_detail.dart';

abstract class QuranRepository {
  Future<Either<Exception, List<Surah>>> getSurahs();
  Future<Either<Exception, SurahDetail>> getSurahDetail(int nomor);
  Future<void> syncSurahsBackground();
}
