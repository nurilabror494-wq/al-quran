import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/di/injection.dart';
import '../bloc/surah_detail/surah_detail_bloc.dart';
import '../bloc/surah_detail/surah_detail_event.dart';
import '../bloc/surah_detail/surah_detail_state.dart';

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

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() => _playingAyahNomor = null);
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
        setState(() => _playingAyahNomor = ayahNomor);
        print('Playing audio for ayah $ayahNomor: $url');
        await _audioPlayer.stop();
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memutar audio')),
      );
      setState(() => _playingAyahNomor = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SurahDetailBloc>()..add(FetchSurahDetail(widget.nomorSurah)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.namaSurah),
        ),
        body: BlocBuilder<SurahDetailBloc, SurahDetailState>(
          builder: (context, state) {
            if (state is SurahDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SurahDetailError) {
              return Center(child: Text(state.message));
            } else if (state is SurahDetailLoaded) {
              final detail = state.surahDetail;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: detail.ayat.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final ayah = detail.ayat[index];
                  final isPlaying = _playingAyahNomor == ayah.nomorAyat;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
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
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 2.0,
                        ),
                      ),
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
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
