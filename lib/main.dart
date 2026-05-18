import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart' as di;
import 'presentation/pages/surah_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Quran Offline',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SurahListPage(),
    );
  }
}
