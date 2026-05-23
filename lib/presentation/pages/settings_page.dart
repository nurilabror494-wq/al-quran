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
              const Divider(),
              const _SectionHeader(title: 'Audio Murottal'),
              ListTile(
                leading: const Icon(Icons.record_voice_over),
                title: const Text('Pengisi Suara (Qari)'),
                subtitle: const Text('Pilih Qari untuk memutar audio'),
                trailing: DropdownButton<String>(
                  value: state.qari,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<SettingsCubit>().updateQari(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'Abdullah-Al-Juhany', child: Text('Abdullah Al-Juhany')),
                    DropdownMenuItem(value: 'Abdul-Muhsin-Al-Qasim', child: Text('Abdul Muhsin Al-Qasim')),
                    DropdownMenuItem(value: 'Abdurrahman-as-Sudais', child: Text('Abdurrahman as-Sudais')),
                    DropdownMenuItem(value: 'Ibrahim-Al-Dossari', child: Text('Ibrahim Al-Dossari')),
                    DropdownMenuItem(value: 'Misyari-Rasyid-Al-Afasi', child: Text('Misyari Rasyid Al-Afasi')),
                    DropdownMenuItem(value: 'Yasser-Al-Dosari', child: Text('Yasser Al-Dosari')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
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
                        fontFamily: 'Amiri', // Add Amiri for better rendering if needed
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
