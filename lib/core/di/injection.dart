import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../data/datasources/local/hive_storage.dart';
import '../../data/datasources/remote/quran_remote_datasource.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../presentation/bloc/surah_list/surah_list_bloc.dart';
import '../../presentation/bloc/surah_detail/surah_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  
  // Local Storage
  final hiveStorage = HiveStorage();
  await hiveStorage.init();
  sl.registerLazySingleton<HiveStorage>(() => hiveStorage);

  // Data sources
  sl.registerLazySingleton<QuranRemoteDataSource>(
    () => QuranRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Blocs
  sl.registerFactory(() => SurahListBloc(repository: sl()));
  sl.registerFactory(() => SurahDetailBloc(repository: sl()));
}
