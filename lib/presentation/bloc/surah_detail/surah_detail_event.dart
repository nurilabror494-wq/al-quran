import 'package:equatable/equatable.dart';

abstract class SurahDetailEvent extends Equatable {
  const SurahDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSurahDetail extends SurahDetailEvent {
  final int nomor;

  const FetchSurahDetail(this.nomor);

  @override
  List<Object> get props => [nomor];
}
