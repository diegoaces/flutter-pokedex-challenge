import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/providers/dio_provider.dart';
import 'package:poke_app/widgets/error_widget.dart';
import 'package:poke_app/widgets/pokeball_loading.dart';

class PokedexWidget extends ConsumerWidget {
  const PokedexWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);
    return FutureBuilder(
      future: dio.get('/pokemon'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 50, width: 50, child: PokeballLoading());
        } else if (snapshot.hasError) {
          return PokedexErrorWidget();
        } else {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data!.data['results'].length,
            itemBuilder: (context, index) {
              final pokemon = data.data['results'][index];
              return ListTile(title: Text(pokemon['name']));
            },
          );
        }
      },
    );
  }
}
