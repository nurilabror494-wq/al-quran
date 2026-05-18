import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../bloc/surah_list/surah_list_bloc.dart';
import '../bloc/surah_list/surah_list_event.dart';
import '../bloc/surah_list/surah_list_state.dart';
import 'surah_detail_page.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahListBloc>()..add(FetchSurahList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Al-Quran Offline', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildSurahList()),
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
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailPage(
                        nomorSurah: surah.nomor,
                        namaSurah: surah.namaLatin,
                      ),
                    ),
                  );
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
