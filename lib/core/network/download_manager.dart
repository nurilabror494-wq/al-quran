import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../data/datasources/local/hive_storage.dart';

class DownloadManager {
  final Dio dio;
  final HiveStorage hiveStorage;

  DownloadManager({required this.dio, required this.hiveStorage});

  Future<String?> downloadAudio(String url, String fileName, Function(int, int)? onReceiveProgress) async {
    try {
      final cachedPath = hiveStorage.getDownloadedAudioPath(url);
      if (cachedPath != null && await File(cachedPath).exists()) {
        return cachedPath;
      }

      final dir = await getApplicationDocumentsDirectory();
      final savePath = p.join(dir.path, 'audio', fileName);
      
      final directory = Directory(p.dirname(savePath));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      await dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );

      await hiveStorage.saveDownloadedAudioPath(url, savePath);
      return savePath;
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  String? getLocalPathIfDownloaded(String url) {
    return hiveStorage.getDownloadedAudioPath(url);
  }
}
