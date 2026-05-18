import 'package:hive_flutter/hive_flutter.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/surah_detail_model.dart';
import '../models/tafsir_model.dart';

class HiveStorage {
  static const String surahsBoxName = 'surahs_box';
  static const String surahDetailBoxName = 'surah_detail_box';

  Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(SurahModelAdapter());
    Hive.registerAdapter(AyahModelAdapter());
    Hive.registerAdapter(SurahDetailModelAdapter());
    Hive.registerAdapter(TafsirModelAdapter());

    await Hive.openBox<List>(surahsBoxName);
    await Hive.openBox<SurahDetailModel>(surahDetailBoxName);
  }

  Future<void> saveSurahs(List<SurahModel> surahs) async {
    final box = Hive.box<List>(surahsBoxName);
    await box.put('all_surahs', surahs);
  }

  List<SurahModel>? getSurahs() {
    final box = Hive.box<List>(surahsBoxName);
    final data = box.get('all_surahs');
    if (data != null) {
      return data.cast<SurahModel>();
    }
    return null;
  }

  Future<void> saveSurahDetail(SurahDetailModel surahDetail) async {
    final box = Hive.box<SurahDetailModel>(surahDetailBoxName);
    await box.put(surahDetail.nomor, surahDetail);
  }

  SurahDetailModel? getSurahDetail(int nomor) {
    final box = Hive.box<SurahDetailModel>(surahDetailBoxName);
    return box.get(nomor);
  }
}
