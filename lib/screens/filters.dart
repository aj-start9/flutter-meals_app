import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/filters_provider.dart';


class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({
    super.key,
  });

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  late bool _glutenFreeSet;
  late bool _lactoseFreeSet;
  late bool _veganSet;
  late bool _vegetarianSet;

  @override
  void initState() {
    super.initState();
    _glutenFreeSet = ref.read(filtersProvider)[Filter.glutenFree] ?? false;
    _lactoseFreeSet = ref.read(filtersProvider)[Filter.lactoseFree] ?? false;
    _veganSet = ref.read(filtersProvider)[Filter.vegan] ?? false;
    _vegetarianSet = ref.read(filtersProvider)[Filter.vegetarian] ?? false;
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 24,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Filters')),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          ref.read(filtersProvider.notifier).setAllFilters({
            Filter.glutenFree: _glutenFreeSet,
            Filter.lactoseFree: _lactoseFreeSet,
            Filter.vegetarian: _vegetarianSet,
            Filter.vegan: _veganSet,
          });
        },
        child: Column(
          children: [
            _buildSwitchListTile(
              title: 'Gluten-free',
              subtitle: 'Only include gluten-free meals.',
              value: _glutenFreeSet,
              onChanged: (value) {
                setState(() {
                  _glutenFreeSet = value;
                });
              },
            ),
            _buildSwitchListTile(
              title: 'Lactose-free',
              subtitle: 'Only include lactose-free meals.',
              value: _lactoseFreeSet,
              onChanged: (value) {
                setState(() {
                  _lactoseFreeSet = value;
                });
              },
            ),
            _buildSwitchListTile(
              title: 'Vegetarian',
              subtitle: 'Only include vegetarian meals.',
              value: _vegetarianSet,
              onChanged: (value) {
                setState(() {
                  _vegetarianSet = value;
                });
              },
            ),
            _buildSwitchListTile(
              title: 'Vegan',
              subtitle: 'Only include vegan meals.',
              value: _veganSet,
              onChanged: (value) {
                setState(() {
                  _veganSet = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}