import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_error_widget.dart';
import '../../data/models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_details_screen.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  final _ingredientController = TextEditingController();
  final _ingredients = <String>[];

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredientFromField() {
    final value = _ingredientController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _ingredients.add(value);
      _ingredientController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Рецепты')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: const InputDecoration(
                      labelText: 'Ингредиенты',
                      hintText: 'Добавьте ингредиент и нажмите «+»',
                    ),
                    enabled: !state.isLoading,
                    textInputAction: TextInputAction.done,
                    onSubmitted: state.isLoading ? null : (_) => _addIngredientFromField(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: state.isLoading ? null : _addIngredientFromField,
                  icon: const Icon(Icons.add),
                  tooltip: 'Добавить',
                ),
              ],
            ),
            if (_ingredients.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ingredients
                    .map(
                      (i) => InputChip(
                        label: Text(i),
                        onDeleted: state.isLoading
                            ? null
                            : () => setState(() => _ingredients.remove(i)),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      _addIngredientFromField();
                      if (_ingredients.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Добавьте хотя бы один ингредиент')),
                        );
                        return;
                      }
                      ref.read(recipeProvider.notifier).generate(ingredients: [..._ingredients]);
                    },
              child: state.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Сгенерировать'),
            ),
            const SizedBox(height: 16),
            _Result(state: state),
          ],
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  final AsyncValue<List<RecipeModel>> state;
  const _Result({required this.state});

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
      error: (e, _) => AppErrorWidget(message: e.toString()),
      data: (recipes) {
        if (recipes.isEmpty) return const Text('Рецептов пока нет. Сгенерируйте.');
        return Column(
          children: recipes
              .map(
                (r) => RecipeCard(
                  recipe: r,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: r)),
                    );
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}

