import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:alquran_apps/data/datasources/remote/quran_remote_datasource.dart';
import 'package:alquran_apps/core/network/dio_client.dart';

void main() async {
  final dioClient = DioClient();
  final remote = QuranRemoteDataSourceImpl(dioClient: dioClient);
  final detail = await remote.getSurahDetail(1);
  for (var ayah in detail.ayatModels.take(3)) {
    print('Ayah ${ayah.nomorAyat}: ${ayah.audio}');
  }
}
