import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String themeMode; // 'system', 'light', 'dark'
  final double arabicFontSize;
  final bool showTranslation;

  const SettingsState({
    this.themeMode = 'system',
    this.arabicFontSize = 28.0,
    this.showTranslation = true,
  });

  SettingsState copyWith({
    String? themeMode,
    double? arabicFontSize,
    bool? showTranslation,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }

  @override
  List<Object> get props => [themeMode, arabicFontSize, showTranslation];
}
