import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/di/injection.dart';
import '../bloc/surah_detail/surah_detail_bloc.dart';
import '../bloc/surah_detail/surah_detail_event.dart';
import '../bloc/surah_detail/surah_detail_state.dart';
import '../../core/network/download_manager.dart';
import '../../data/datasources/local/hive_storage.dart';
import 'tafsir_page.dart';
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomorSurah;
  final String namaSurah;

  const SurahDetailPage({
    super.key,
    required this.nomorSurah,
    required this.namaSurah,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyahNomor;
  bool _isPlayingFullSurah = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    // Save Last Read
    sl<HiveStorage>().saveLastRead(widget.nomorSurah, 1, widget.namaSurah);
    
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _playingAyahNomor = null;
            _isPlayingFullSurah = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String url, int ayahNomor) async {
    try {
      if (_playingAyahNomor == ayahNomor && _audioPlayer.playing) {
        await _audioPlayer.pause();
        setState(() => _playingAyahNomor = null);
      } else {
        setState(() {
          _playingAyahNomor = ayahNomor;
          _isPlayingFullSurah = false;
        });
        
        // Check if downloaded
        final localPath = sl<DownloadManager>().getLocalPathIfDownloaded(url);
        final playUrl = localPath ?? url;

        await _audioPlayer.stop();
        if (localPath != null) {
          await _audioPlayer.setFilePath(localPath);
        } else {
          await _audioPlayer.setUrl(playUrl);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memutar audio')),
      );
      setState(() => _playingAyahNomor = null);
    }
  }

  void _playFullSurah(String url) async {
    try {
      if (_isPlayingFullSurah && _audioPlayer.playing) {
        await _audioPlayer.pause();
        setState(() => _isPlayingFullSurah = false);
      } else {
        setState(() {
          _isPlayingFullSurah = true;
          _playingAyahNomor = null;
        });
        
        final localPath = sl<DownloadManager>().getLocalPathIfDownloaded(url);
        final playUrl = localPath ?? url;

        await _audioPlayer.stop();
        if (localPath != null) {
          await _audioPlayer.setFilePath(localPath);
        } else {
          await _audioPlayer.setUrl(playUrl);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memutar audio')),
      );
      setState(() => _isPlayingFullSurah = false);
    }
  }

  void _downloadFullSurah(String url) async {
    setState(() => _isDownloading = true);
    final path = await sl<DownloadManager>().downloadAudio(url, 'surah_${widget.nomorSurah}.mp3', null);
    if (!mounted) return;
    setState(() => _isDownloading = false);
    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download selesai!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download gagal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahDetailBloc>()..add(FetchSurahDetail(widget.nomorSurah)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.namaSurah),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_book),
              tooltip: 'Tafsir',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TafsirPage(
                      nomorSurah: widget.nomorSurah,
                      namaSurah: widget.namaSurah,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SurahDetailBloc, SurahDetailState>(
          builder: (context, state) {
            if (state is SurahDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SurahDetailError) {
              return Center(child: Text(state.message));
            } else if (state is SurahDetailLoaded) {
              final detail = state.surahDetail;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _playFullSurah(detail.audioFull),
                          icon: Icon(_isPlayingFullSurah ? Icons.pause : Icons.play_arrow),
                          label: const Text('Full Murottal'),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        if (_isDownloading)
                          const CircularProgressIndicator()
                        else
                          OutlinedButton.icon(
                            onPressed: () => _downloadFullSurah(detail.audioFull),
                            icon: const Icon(Icons.download),
                            label: const Text('Download'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: detail.ayat.length,
                      separatorBuilder: (context, index) => const Divider(height: 32),
                      itemBuilder: (context, index) {
                        final ayah = detail.ayat[index];
                        final isPlaying = _playingAyahNomor == ayah.nomorAyat;
                        
                        return BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, settingsState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Theme.of(context).dividerColor.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Text(
                                        'Ayat ${ayah.nomorAyat}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                                      color: Theme.of(context).primaryColor,
                                      iconSize: 36,
                                      onPressed: () {
                                        _playAudio(ayah.audio, ayah.nomorAyat);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  ayah.teksArab,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: settingsState.arabicFontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Amiri', // Added Amiri font family
                                    height: 2.0,
                                  ),
                                ),
                                if (settingsState.showTranslation) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    ayah.teksLatin,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ayah.teksIndonesia,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ],
                            );
                          },
                        );
                      },
              ),
            ),
          ],
        );
      }
      return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
