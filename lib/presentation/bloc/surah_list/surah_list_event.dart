import 'package:equatable/equatable.dart';

abstract class SurahListEvent extends Equatable {
  const SurahListEvent();

  @override
  List<Object> get props => [];
}

class FetchSurahList extends SurahListEvent {}

class SearchSurah extends SurahListEvent {
  final String query;

  const SearchSurah(this.query);

  @override
  List<Object> get props => [query];
}
