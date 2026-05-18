import 'package:equatable/equatable.dart';
import '../../../domain/entities/surah_detail.dart';

abstract class SurahDetailState extends Equatable {
  const SurahDetailState();

  @override
  List<Object> get props => [];
}

class SurahDetailInitial extends SurahDetailState {}

class SurahDetailLoading extends SurahDetailState {}

class SurahDetailLoaded extends SurahDetailState {
  final SurahDetail surahDetail;

  const SurahDetailLoaded({required this.surahDetail});

  @override
  List<Object> get props => [surahDetail];
}

class SurahDetailError extends SurahDetailState {
  final String message;

  const SurahDetailError(this.message);

  @override
  List<Object> get props => [message];
}
