import '../../models/surah_model.dart';
import '../../models/surah_detail_model.dart';
import '../../models/tafsir_model.dart';
import '../../../core/network/dio_client.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<SurahDetailModel> getSurahDetail(int nomor);
  Future<List<TafsirModel>> getTafsir(int nomor);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  final DioClient dioClient;

  QuranRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SurahModel>> getSurahs() async {
    final response = await dioClient.dio.get('surat');
    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data.map((e) => SurahModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  Future<SurahDetailModel> getSurahDetail(int nomor) async {
    final response = await dioClient.dio.get('surat/$nomor');
    if (response.statusCode == 200) {
      final data = response.data['data'];
      return SurahDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load surah detail');
    }
  }

  @override
  Future<List<TafsirModel>> getTafsir(int nomor) async {
    final response = await dioClient.dio.get('tafsir/$nomor');
    if (response.statusCode == 200) {
      final data = response.data['data']['tafsir'] as List;
      return data.map((e) => TafsirModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tafsir');
    }
  }
}
