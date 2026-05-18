import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../bloc/surah_list/surah_list_bloc.dart';
import '../bloc/surah_list/surah_list_event.dart';
import '../bloc/surah_list/surah_list_state.dart';
import 'surah_detail_page.dart';
import '../../data/datasources/local/hive_storage.dart';
import 'settings_page.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahListBloc>()..add(FetchSurahList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Al-Quran Offline', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Pengaturan',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildLastRead(),
            _buildSearchBar(),
            Expanded(child: _buildSurahList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLastRead() {
    final lastRead = sl<HiveStorage>().getLastRead();
    if (lastRead == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(76),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terakhir Dibaca',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Surat ${lastRead['namaSurah']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ayat ${lastRead['nomorAyat']}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 36),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailPage(
                          nomorSurah: lastRead['nomorSurah'],
                          namaSurah: lastRead['namaSurah'],
                        ),
                      ),
                    );
                    _refresh();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white70),
                  tooltip: 'Hapus Riwayat',
                  onPressed: () async {
                    await sl<HiveStorage>().clearLastRead();
                    _refresh();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Riwayat bacaan dihapus')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari surat...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
            onChanged: (query) {
              context.read<SurahListBloc>().add(SearchSurah(query));
            },
          ),
        );
      }
    );
  }

  Widget _buildSurahList() {
    return BlocBuilder<SurahListBloc, SurahListState>(
      builder: (context, state) {
        if (state is SurahListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SurahListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(state.message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<SurahListBloc>().add(FetchSurahList()),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (state is SurahListLoaded) {
          final surahs = state.searchResults;
          if (surahs.isEmpty) {
            return const Center(child: Text('Surat tidak ditemukan.'));
          }
          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withAlpha(25),
                  ),
                  child: Text(
                    surah.nomor.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                title: Text(surah.namaLatin, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${surah.arti} • ${surah.jumlahAyat} Ayat'),
                trailing: Text(
                  surah.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri', // Assuming standard arabic font is not needed or we rely on system
                  ),
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailPage(
                        nomorSurah: surah.nomor,
                        namaSurah: surah.namaLatin,
                      ),
                    ),
                  );
                  _refresh();
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
