import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/local/hive_storage.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final HiveStorage hiveStorage;

  SettingsCubit({required this.hiveStorage}) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeMode = hiveStorage.getSettings('themeMode', defaultValue: 'system');
    final arabicFontSize = hiveStorage.getSettings('arabicFontSize', defaultValue: 28.0);
    final showTranslation = hiveStorage.getSettings('showTranslation', defaultValue: true);

    emit(SettingsState(
      themeMode: themeMode,
      arabicFontSize: arabicFontSize,
      showTranslation: showTranslation,
    ));
  }

  void updateThemeMode(String mode) {
    hiveStorage.saveSettings('themeMode', mode);
    emit(state.copyWith(themeMode: mode));
  }

  void updateArabicFontSize(double size) {
    hiveStorage.saveSettings('arabicFontSize', size);
    emit(state.copyWith(arabicFontSize: size));
  }

  void toggleTranslation(bool show) {
    hiveStorage.saveSettings('showTranslation', show);
    emit(state.copyWith(showTranslation: show));
  }
}
