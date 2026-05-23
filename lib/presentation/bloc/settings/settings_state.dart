import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String themeMode; // 'system', 'light', 'dark'
  final double arabicFontSize;
  final bool showTranslation;
  final String qari;

  const SettingsState({
    this.themeMode = 'system',
    this.arabicFontSize = 28.0,
    this.showTranslation = true,
    this.qari = 'Abdullah-Al-Juhany',
  });

  SettingsState copyWith({
    String? themeMode,
    double? arabicFontSize,
    bool? showTranslation,
    String? qari,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      showTranslation: showTranslation ?? this.showTranslation,
      qari: qari ?? this.qari,
    );
  }

  @override
  List<Object> get props => [themeMode, arabicFontSize, showTranslation, qari];
}
