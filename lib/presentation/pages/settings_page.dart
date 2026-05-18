import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const _SectionHeader(title: 'Tampilan'),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Tema Gelap'),
                trailing: DropdownButton<String>(
                  value: state.themeMode,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<SettingsCubit>().updateThemeMode(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('Sistem')),
                    DropdownMenuItem(value: 'light', child: Text('Terang')),
                    DropdownMenuItem(value: 'dark', child: Text('Gelap')),
                  ],
                ),
              ),
              const Divider(),
              const _SectionHeader(title: 'Membaca Al-Quran'),
              ListTile(
                leading: const Icon(Icons.text_increase),
                title: const Text('Ukuran Font Arab'),
                subtitle: Slider(
                  value: state.arabicFontSize,
                  min: 20.0,
                  max: 50.0,
                  divisions: 6,
                  label: state.arabicFontSize.round().toString(),
                  onChanged: (double value) {
                    context.read<SettingsCubit>().updateArabicFontSize(value);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.translate),
                title: const Text('Tampilkan Terjemahan & Latin'),
                trailing: Switch(
                  value: state.showTranslation,
                  onChanged: (bool value) {
                    context.read<SettingsCubit>().toggleTranslation(value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pratinjau',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: state.arabicFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.showTranslation) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
