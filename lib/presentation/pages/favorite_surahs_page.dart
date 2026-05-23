import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/di/injection.dart';
import '../../data/datasources/local/hive_storage.dart';
import 'surah_detail_page.dart';

class FavoriteSurahsPage extends StatefulWidget {
  const FavoriteSurahsPage({super.key});

  @override
  State<FavoriteSurahsPage> createState() => _FavoriteSurahsPageState();
}

class _FavoriteSurahsPageState extends State<FavoriteSurahsPage> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat Tersimpan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<List>(HiveStorage.favoritesBoxName).listenable(keys: ['fav_surahs']),
        builder: (context, Box<List> box, _) {
          final favIds = sl<HiveStorage>().getFavorites();
          if (favIds.isEmpty) {
            return _buildEmptyState();
          }

          final allSurahs = sl<HiveStorage>().getSurahs() ?? [];
          final favSurahs = allSurahs.where((s) => favIds.contains(s.nomor)).toList();

          if (favSurahs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: favSurahs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final surah = favSurahs[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
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
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          surah.nomor.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.namaLatin, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${surah.arti} • ${surah.jumlahAyat} Ayat',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          sl<HiveStorage>().toggleFavorite(surah.nomor);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Theme.of(context).dividerColor),
          const SizedBox(height: 16),
          const Text(
            'Belum ada surat yang disimpan.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Simpan surat favorit Anda agar mudah diakses.',
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
        ],
      ),
    );
  }
}
