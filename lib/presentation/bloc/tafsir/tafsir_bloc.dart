import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/quran_repository.dart';
import '../../../domain/entities/tafsir.dart';

// Event
abstract class TafsirEvent extends Equatable {
  const TafsirEvent();
  @override
  List<Object> get props => [];
}

class FetchTafsir extends TafsirEvent {
  final int nomor;
  const FetchTafsir(this.nomor);
  @override
  List<Object> get props => [nomor];
}

// State
abstract class TafsirState extends Equatable {
  const TafsirState();
  @override
  List<Object> get props => [];
}

class TafsirInitial extends TafsirState {}

class TafsirLoading extends TafsirState {}

class TafsirLoaded extends TafsirState {
  final List<Tafsir> tafsirList;
  const TafsirLoaded({required this.tafsirList});
  @override
  List<Object> get props => [tafsirList];
}

class TafsirError extends TafsirState {
  final String message;
  const TafsirError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class TafsirBloc extends Bloc<TafsirEvent, TafsirState> {
  final QuranRepository repository;

  TafsirBloc({required this.repository}) : super(TafsirInitial()) {
    on<FetchTafsir>(_onFetchTafsir);
  }

  Future<void> _onFetchTafsir(FetchTafsir event, Emitter<TafsirState> emit) async {
    emit(TafsirLoading());
    final result = await repository.getTafsir(event.nomor);
    result.fold(
      (error) => emit(TafsirError(error.toString())),
      (data) => emit(TafsirLoaded(tafsirList: data)),
    );
  }
}
