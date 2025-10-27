import 'package:flutter/material.dart';
import 'package:poke_app/colors.dart';
import 'package:poke_app/l10n/app_localizations.dart';
import 'package:poke_app/widgets/custom_default_button.dart';

/// Modal para filtrar preferencias de Pokémon por tipo.
/// Permite seleccionar múltiples tipos y aplicar los filtros.
/// Llama a una función callback al aplicar los filtros seleccionados.
///
/// Parámetros:
/// - onApplyFilters: Función callback que recibe la lista de tipos seleccionados.
/// Ejemplo de uso:
/// showModalBottomSheet(
///   context: context,
///   builder: (context) => FilterPreferencesModal(
///     onApplyFilters: (selectedTypes) {
///       // Procesar los tipos seleccionados
///     },
///   ),
/// );
class FilterPreferencesModal extends StatefulWidget {
  final Function(List<String>) onApplyFilters;

  const FilterPreferencesModal({super.key, required this.onApplyFilters});

  @override
  State<FilterPreferencesModal> createState() => _FilterPreferencesModalState();
}

class _FilterPreferencesModalState extends State<FilterPreferencesModal> {
  // Mapa de tipos: clave es el nombre en inglés (API), valor es el nombre en español (UI)
  final Map<String, String> pokemonTypes = {
    'water': 'Agua',
    'dragon': 'Dragón',
    'electric': 'Eléctrico',
    'fairy': 'Hada',
    'ghost': 'Fantasma',
    'fire': 'Fuego',
    'grass': 'Planta',
    'poison': 'Veneno',
    'normal': 'Normal',
    'fighting': 'Lucha',
    'flying': 'Volador',
    'psychic': 'Psíquico',
    'bug': 'Bicho',
    'rock': 'Roca',
    'ground': 'Tierra',
    'ice': 'Hielo',
    'steel': 'Acero',
    'dark': 'Siniestro',
  };

  late Map<String, bool> selectedTypes;
  late bool isTypeExpanded;

  @override
  void initState() {
    super.initState();
    selectedTypes = {for (var type in pokemonTypes.keys) type: false};
    isTypeExpanded = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.filterByPreferences,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTypeExpanded = !isTypeExpanded;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.type,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        isTypeExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.black,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300], thickness: 1),
              ],
            ),
          ),

          if (isTypeExpanded)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: pokemonTypes.entries.map((entry) {
                    final typeKey = entry.key;
                    final typeLabel = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            typeLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTypes[typeKey] = !selectedTypes[typeKey]!;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedTypes[typeKey]!
                                      ? Colors.blue
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color: selectedTypes[typeKey]!
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              child: selectedTypes[typeKey]!
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          Divider(color: Colors.grey[300], thickness: 2),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomDefaultButton(
                  label: l10n.apply,
                  onPressed: () {
                    final selectedTypesList = selectedTypes.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();

                    widget.onApplyFilters(selectedTypesList);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                CustomDefaultButton(
                  label: l10n.cancel,
                  buttonColor: secondaryDefault,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
