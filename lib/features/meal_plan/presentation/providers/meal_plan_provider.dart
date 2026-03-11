import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/repository/meal_plan_repository.dart';
import '../../data/models/meal_plan_model.dart';

final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  final ai = ref.watch(geminiServiceProvider);
  final db = ref.watch(localDbProvider);
  return MealPlanRepository(ai, db);
});

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, AsyncValue<MealPlanModel?>>((ref) {
  return MealPlanNotifier(ref.watch(mealPlanRepositoryProvider));
});

class MealPlanNotifier extends StateNotifier<AsyncValue<MealPlanModel?>> {
  final MealPlanRepository _repo;

  MealPlanNotifier(this._repo) : super(const AsyncValue.data(null));

  void loadLatest() {
    state = AsyncValue.data(_repo.getLatest());
  }

  Future<void> generate({
    required String goal,
    required int calories,
    required List<String> dietRestrictions,
    required List<String> allergies,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final plan = await _repo.generateAndSave(
        goal: goal,
        calories: calories,
        dietRestrictions: dietRestrictions,
        allergies: allergies,
      );
      return plan;
    });
  }
}

