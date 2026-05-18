import 'package:hive_flutter/hive_flutter.dart';
import '../../models/surah_model.dart';
import '../../models/ayah_model.dart';
import '../../models/surah_detail_model.dart';
import '../../models/tafsir_model.dart';

class HiveStorage {
  static const String surahsBoxName = 'surahs_box';
  static const String surahDetailBoxName = 'surah_detail_box';
  static const String tafsirBoxName = 'tafsir_box';
  static const String lastReadBoxName = 'last_read_box';
  static const String downloadBoxName = 'download_box';

  Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(SurahModelAdapter());
    Hive.registerAdapter(AyahModelAdapter());
    Hive.registerAdapter(SurahDetailModelAdapter());
    Hive.registerAdapter(TafsirModelAdapter());

    await Hive.openBox<List>(surahsBoxName);
    await Hive.openBox<SurahDetailModel>(surahDetailBoxName);
    await Hive.openBox<List>(tafsirBoxName);
    await Hive.openBox<Map>(lastReadBoxName);
    await Hive.openBox<String>(downloadBoxName);
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

  Future<void> saveTafsir(int nomor, List<TafsirModel> tafsir) async {
    final box = Hive.box<List>(tafsirBoxName);
    await box.put(nomor, tafsir);
  }

  List<TafsirModel>? getTafsir(int nomor) {
    final box = Hive.box<List>(tafsirBoxName);
    final data = box.get(nomor);
    if (data != null) {
      return data.cast<TafsirModel>();
    }
    return null;
  }

  Future<void> saveLastRead(int nomorSurah, int nomorAyat, String namaSurah) async {
    final box = Hive.box<Map>(lastReadBoxName);
    await box.put('last_read', {
      'nomorSurah': nomorSurah,
      'nomorAyat': nomorAyat,
      'namaSurah': namaSurah,
    });
  }

  Map? getLastRead() {
    final box = Hive.box<Map>(lastReadBoxName);
    return box.get('last_read');
  }

  Future<void> saveDownloadedAudioPath(String url, String localPath) async {
    final box = Hive.box<String>(downloadBoxName);
    await box.put(url, localPath);
  }

  String? getDownloadedAudioPath(String url) {
    final box = Hive.box<String>(downloadBoxName);
    return box.get(url);
  }
}
