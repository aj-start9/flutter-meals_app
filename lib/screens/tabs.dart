import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/filters_provider.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/providers/meals_provider.dart';
import 'package:meal_app/providers/favorites_provider.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedTabIndex = 0;

  void _selectedTabIndexHandler(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _setScreen(String type) async {
    Navigator.of(context).pop();
    if (type == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (context) => FiltersScreen()),
      );
      ref.read(filtersProvider.notifier).setFilter(Filter.glutenFree, result?[Filter.glutenFree] ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final availableMeals = meals.where((meal) {
      if (activeFilters[Filter.glutenFree] == true && !meal.isGlutenFree) return false;
      if (activeFilters[Filter.lactoseFree] == true && !meal.isLactoseFree) return false;
      if (activeFilters[Filter.vegetarian] == true && !meal.isVegetarian) return false;
      if (activeFilters[Filter.vegan] == true && !meal.isVegan) return false;
      return true;
    }).toList();

    Widget activeScreen  = CategoriesScreen(availableMeals: availableMeals);
    if (_selectedTabIndex == 1) {
      final favoritesMeals = ref.watch(favoritesProvider);
      activeScreen = MealsScreen(
        meals: favoritesMeals,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTabIndex == 0 ? 'Categories' : 'Favorites'),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (int index) {
          _selectedTabIndexHandler(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
