import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_app/l10n/app_localizations.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/widgets/pokemon_list_tile.dart';
import 'package:poke_app/widgets/filter_preferences_modal.dart';

class PokedexWidget extends StatefulWidget {
  const PokedexWidget({super.key, required this.pokemons});

  final List<Pokemon> pokemons;

  @override
  State<PokedexWidget> createState() => _PokedexWidgetState();
}

class _PokedexWidgetState extends State<PokedexWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Pokemon> _filteredPokemons = [];
  List<String> _selectedTypeFilters = [];

  @override
  void initState() {
    super.initState();
    _filteredPokemons = widget.pokemons;
  }

  @override
  void didUpdateWidget(PokedexWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pokemons != widget.pokemons) {
      _applyFilters();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      var filtered = widget.pokemons;

      // Filtrar por texto de búsqueda
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text;
        filtered = filtered
            .where((pokemon) =>
                pokemon.name.toLowerCase().contains(query.toLowerCase()) ||
                pokemon.id.toString().contains(query))
            .toList();
      }

      // Filtrar por tipos seleccionados
      if (_selectedTypeFilters.isNotEmpty) {
        filtered = filtered.where((pokemon) {
          return pokemon.types.any((type) => _selectedTypeFilters.contains(type));
        }).toList();
      }

      _filteredPokemons = filtered;
    });
  }

  void _filterPokemons(String query) {
    _applyFilters();
  }

  void _onApplyTypeFilters(List<String> selectedTypes) {
    setState(() {
      _selectedTypeFilters = selectedTypes;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
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
                      hintText: l10n.searchPokemon,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/svg/search.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.grey[400]!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400]),
                              onPressed: () {
                                _searchController.clear();
                                _filterPokemons('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    onChanged: _filterPokemons,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => FilterPreferencesModal(
                      onApplyFilters: _onApplyTypeFilters,
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(
                      'assets/svg/search.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        Colors.grey[400]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_selectedTypeFilters.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.resultsFound(_filteredPokemons.length),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTypeFilters = [];
                    });
                    _applyFilters();
                  },
                  child: Text(
                    l10n.clearFilter,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _filteredPokemons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noResultsFound,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.tryAnotherSearch,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredPokemons.length,
                    itemBuilder: (context, index) {
                      return PokemonListTile(pokemon: _filteredPokemons[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
