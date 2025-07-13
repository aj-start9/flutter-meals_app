import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wasAddedd = ref.read(favoritesProvider.notifier).isFavorite(meal);
    ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoritesProvider.notifier)
                  .toggleFavorite(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: wasAdded
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                  content: Text(
                    wasAdded
                        ? 'Added to favorites!'
                        : 'Removed from favorites!',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animate) {
                return RotationTransition(
                  turns: Tween(
                    begin: 0.5,
                    end: 1.0,
                  ).animate(animate),
                  child: child,
                );
              },
              child: wasAddedd
                  ? Icon(Icons.star, key: ValueKey(wasAddedd))
                  : Icon(Icons.star_border, key: ValueKey(wasAddedd)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            ...meal.ingredients.map(
              (ingredient) => Text(ingredient, style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            ...meal.steps.map(
              (step) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
