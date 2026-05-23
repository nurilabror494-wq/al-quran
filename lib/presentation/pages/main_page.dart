import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../../data/datasources/local/hive_storage.dart';
import '../bloc/surah_list/surah_list_bloc.dart';
import '../bloc/surah_list/surah_list_event.dart';
import 'surah_list_page.dart';
import 'settings_page.dart';
import 'surah_detail_page.dart';
import 'favorite_surahs_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SurahListPage(),
    const FavoriteSurahsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Al-Quran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Tersimpan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assalamu\'alaikum,',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Hamba Allah',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SurahListPage(focusSearch: true)),
                            );
                          },
                          icon: const Icon(Icons.search, size: 28),
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildLastReadHero(isDarkMode, primaryColor),
                    const SizedBox(height: 32),
                    const Text(
                      'Surat Pilihan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPopularSurahs(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastReadHero(bool isDarkMode, Color primaryColor) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Map>(HiveStorage.lastReadBoxName).listenable(keys: ['last_read']),
      builder: (context, Box<Map> box, _) {
        final lastRead = box.get('last_read');
        
        return GestureDetector(
          onTap: () async {
            if (lastRead != null) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailPage(
                    nomorSurah: lastRead['nomorSurah'],
                    namaSurah: lastRead['namaSurah'],
                  ),
                ),
              );
            } else {
              // If no last read, just go to Al-Fatihah
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SurahDetailPage(
                    nomorSurah: 1,
                    namaSurah: 'Al-Fatihah',
                  ),
                ),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Watermark Icon
                Positioned(
                  right: -20,
                  bottom: -30,
                  child: Icon(
                    Icons.menu_book,
                    size: 140,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.import_contacts, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            lastRead != null ? 'Terakhir Dibaca' : 'Mulai Membaca',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        lastRead != null ? lastRead['namaSurah'] : 'Al-Fatihah',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastRead != null ? 'Ayat ${lastRead['nomorAyat']}' : 'Ayat 1',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularSurahs() {
    final List<Map<String, dynamic>> popularSurahs = [
      {'nomor': 36, 'nama': 'Yasin', 'arti': 'Yasin'},
      {'nomor': 18, 'nama': 'Al-Kahf', 'arti': 'Gua'},
      {'nomor': 55, 'nama': 'Ar-Rahman', 'arti': 'Yang Maha Pemurah'},
      {'nomor': 67, 'nama': 'Al-Mulk', 'arti': 'Kerajaan'},
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: popularSurahs.length,
      itemBuilder: (context, index) {
        final surah = popularSurahs[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahDetailPage(
                  nomorSurah: surah['nomor'],
                  namaSurah: surah['nama'],
                ),
              ),
            );
            _refresh();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${surah['nomor']}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah['nama'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        surah['arti'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
