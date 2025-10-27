import 'package:flutter/material.dart';

class PokemonSearchBar extends StatefulWidget {
  const PokemonSearchBar({super.key});

  @override
  State<PokemonSearchBar> createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Campo de búsqueda
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Procurar Pokémon...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                    ),
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _performSearch(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botón de búsqueda circular
              GestureDetector(
                onTap: () {
                  if (_searchController.text.isNotEmpty) {
                    _performSearch(_searchController.text);
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    color: Colors.white,
                  ),
                  child: Icon(Icons.search, color: Colors.grey[400], size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buscando Pokémon: $query'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
