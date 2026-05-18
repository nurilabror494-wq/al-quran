import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/quran_repository.dart';
import 'surah_detail_event.dart';
import 'surah_detail_state.dart';

class SurahDetailBloc extends Bloc<SurahDetailEvent, SurahDetailState> {
  final QuranRepository repository;

  SurahDetailBloc({required this.repository}) : super(SurahDetailInitial()) {
    on<FetchSurahDetail>(_onFetchSurahDetail);
  }

  Future<void> _onFetchSurahDetail(
      FetchSurahDetail event, Emitter<SurahDetailState> emit) async {
    emit(SurahDetailLoading());
    final result = await repository.getSurahDetail(event.nomor);
    result.fold(
      (error) => emit(SurahDetailError(error.toString())),
      (data) => emit(SurahDetailLoaded(surahDetail: data)),
    );
  }
}
