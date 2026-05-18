import 'package:equatable/equatable.dart';
import '../../../domain/entities/surah.dart';

abstract class SurahListState extends Equatable {
  const SurahListState();

  @override
  List<Object> get props => [];
}

class SurahListInitial extends SurahListState {}

class SurahListLoading extends SurahListState {}

class SurahListLoaded extends SurahListState {
  final List<Surah> surahs;
  final List<Surah> searchResults;

  const SurahListLoaded({required this.surahs, required this.searchResults});

  @override
  List<Object> get props => [surahs, searchResults];
}

class SurahListError extends SurahListState {
  final String message;

  const SurahListError(this.message);

  @override
  List<Object> get props => [message];
}
