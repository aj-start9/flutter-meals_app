import 'package:meal_app/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  //why we are using remove and add?
  bool toggleFavorite(Meal meal) {
    if (state.contains(meal)) {
      state = state.where((m) => m.id != meal.id).toList();
      return false; // Meal was removed from favorites
    } else {
      state = [...state, meal];
      return true;
    }
  }

  bool isFavorite(Meal meal) {
    return state.contains(meal);
  }
}

final favoritesProvider = StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});