import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier() : super({
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false,
  });

  void setFilter(Filter filter, bool value) {
    state = {...state, filter: value};
  }

  void setAllFilters(Map<Filter, bool> filters) {
    state = filters;
  }

}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree] == true && !meal.isGlutenFree) return false;
    if (activeFilters[Filter.lactoseFree] == true && !meal.isLactoseFree) return false;
    if (activeFilters[Filter.vegetarian] == true && !meal.isVegetarian) return false;
    if (activeFilters[Filter.vegan] == true && !meal.isVegan) return false;
    return true;
  }).toList();
});