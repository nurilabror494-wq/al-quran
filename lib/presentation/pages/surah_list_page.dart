import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../bloc/surah_list/surah_list_bloc.dart';
import '../bloc/surah_list/surah_list_event.dart';
import '../bloc/surah_list/surah_list_state.dart';
import 'surah_detail_page.dart';

class SurahListPage extends StatefulWidget {
  final bool focusSearch;

  const SurahListPage({super.key, this.focusSearch = false});

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    if (widget.focusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahListBloc>()..add(FetchSurahList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Surat', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
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
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: TextField(
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Cari surat...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: surahs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final surah = surahs[index];
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
                      Text(
                        surah.nama,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Amiri', // assuming device has it or falls back to system arabic
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
