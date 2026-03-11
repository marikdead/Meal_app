import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repository/recipe_repository.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final ai = ref.watch(geminiServiceProvider);
  final db = ref.watch(localDbProvider);
  return RecipeRepository(ai, db);
});

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, AsyncValue<List<RecipeModel>>>((ref) {
  return RecipeNotifier(ref.watch(recipeRepositoryProvider));
});

class RecipeNotifier extends StateNotifier<AsyncValue<List<RecipeModel>>> {
  final RecipeRepository _repo;

  RecipeNotifier(this._repo) : super(const AsyncValue.data([]));

  Future<void> generate({required List<String> ingredients}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.generateAndSave(ingredients: ingredients));
  }
}

