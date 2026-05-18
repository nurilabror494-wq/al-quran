import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../bloc/tafsir/tafsir_bloc.dart';

class TafsirPage extends StatelessWidget {
  final int nomorSurah;
  final String namaSurah;

  const TafsirPage({
    super.key,
    required this.nomorSurah,
    required this.namaSurah,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TafsirBloc>()..add(FetchTafsir(nomorSurah)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tafsir $namaSurah'),
        ),
        body: BlocBuilder<TafsirBloc, TafsirState>(
          builder: (context, state) {
            if (state is TafsirLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TafsirError) {
              return Center(child: Text(state.message));
            } else if (state is TafsirLoaded) {
              final tafsirList = state.tafsirList;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tafsirList.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final tafsir = tafsirList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Ayat ${tafsir.ayat}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tafsir.teks,
                        style: const TextStyle(fontSize: 16, height: 1.5),
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
