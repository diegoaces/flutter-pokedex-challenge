import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/pages/pokedex_widget.dart';
import 'package:poke_app/providers/dio_provider.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';
import 'package:poke_app/widgets/error_widget.dart';
import 'package:poke_app/widgets/pokeball_loading.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: dio.get('/pokemon'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: PokeballLoading(),
                ),
              );
            } else if (snapshot.hasError) {
              return PokedexErrorWidget();
            } else {
              final data = snapshot.data;
              return PokedexWidget(data: data);
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
