import 'package:flutter/material.dart';

import '../../data/models/recipe_model.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('${recipe.calories} ккал', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text('Ингредиенты', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((i) => Text('• $i')),
            const SizedBox(height: 16),
            Text('Шаги', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map((e) => Text('${e.key + 1}. ${e.value}')),
          ],
        ),
      ),
    );
  }
}

