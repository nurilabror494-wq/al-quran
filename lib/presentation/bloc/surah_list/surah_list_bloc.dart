import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/quran_repository.dart';
import '../../../domain/entities/surah.dart';
import 'surah_list_event.dart';
import 'surah_list_state.dart';

class SurahListBloc extends Bloc<SurahListEvent, SurahListState> {
  final QuranRepository repository;
  List<Surah> _allSurahs = [];

  SurahListBloc({required this.repository}) : super(SurahListInitial()) {
    on<FetchSurahList>(_onFetchSurahList);
    on<SearchSurah>(_onSearchSurah);
  }

  Future<void> _onFetchSurahList(
      FetchSurahList event, Emitter<SurahListState> emit) async {
    emit(SurahListLoading());
    final result = await repository.getSurahs();
    result.fold(
      (error) => emit(SurahListError(error.toString())),
      (data) {
        _allSurahs = data;
        emit(SurahListLoaded(surahs: _allSurahs, searchResults: _allSurahs));
        repository.syncSurahsBackground(); // sync in background
      },
    );
  }

  void _onSearchSurah(SearchSurah event, Emitter<SurahListState> emit) {
    if (state is SurahListLoaded) {
      final query = event.query.toLowerCase();
      final filtered = _allSurahs.where((surah) {
        return surah.namaLatin.toLowerCase().contains(query) ||
            surah.arti.toLowerCase().contains(query);
      }).toList();
      emit(SurahListLoaded(surahs: _allSurahs, searchResults: filtered));
    }
  }
}
