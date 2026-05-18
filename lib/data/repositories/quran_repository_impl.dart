import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/surah_detail.dart';
import '../../domain/entities/tafsir.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/local/hive_storage.dart';
import '../datasources/remote/quran_remote_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource remoteDataSource;
  final HiveStorage localDataSource;

  QuranRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Exception, List<Surah>>> getSurahs() async {
    try {
      // 1. Try to get from local
      final localData = localDataSource.getSurahs();
      if (localData != null && localData.isNotEmpty) {
        return Right(localData);
      }

      // 2. Fetch from API if local is empty
      final remoteData = await remoteDataSource.getSurahs();
      
      // 3. Save to Local
      await localDataSource.saveSurahs(remoteData);
      
      // 4. Return
      return Right(remoteData);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, SurahDetail>> getSurahDetail(int nomor) async {
    try {
      // 1. Try to get from local
      final localData = localDataSource.getSurahDetail(nomor);
      if (localData != null) {
        return Right(localData);
      }

      // 2. Fetch from API
      final remoteData = await remoteDataSource.getSurahDetail(nomor);

      // 3. Save to Local
      await localDataSource.saveSurahDetail(remoteData);

      // 4. Return
      return Right(remoteData);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<Tafsir>>> getTafsir(int nomor) async {
    try {
      final localData = localDataSource.getTafsir(nomor);
      if (localData != null && localData.isNotEmpty) {
        return Right(localData);
      }

      final remoteData = await remoteDataSource.getTafsir(nomor);
      await localDataSource.saveTafsir(nomor, remoteData);
      return Right(remoteData);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<void> syncSurahsBackground() async {
    try {
      final remoteData = await remoteDataSource.getSurahs();
      await localDataSource.saveSurahs(remoteData);
      if (kDebugMode) {
        print('Background sync completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Background sync failed: $e');
      }
    }
  }
}
