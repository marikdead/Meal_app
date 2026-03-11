import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/models/grocery_list_model.dart';
import '../../data/repository/grocery_repository.dart';

final groceryRepositoryProvider = Provider<GroceryRepository>((ref) {
  final ai = ref.watch(geminiServiceProvider);
  final db = ref.watch(localDbProvider);
  return GroceryRepository(ai, db);
});

final groceryProvider =
    StateNotifierProvider<GroceryNotifier, AsyncValue<GroceryListModel?>>((ref) {
  return GroceryNotifier(ref.watch(groceryRepositoryProvider));
});

class GroceryNotifier extends StateNotifier<AsyncValue<GroceryListModel?>> {
  final GroceryRepository _repo;

  GroceryNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> generateFromLatestMealPlan() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final plan = _repo.getLatestMealPlan();
      if (plan == null) {
        throw Exception('Сначала сгенерируйте план питания');
      }
      return _repo.generateFromMealPlanAndSave(plan);
    });
  }

  Future<void> toggleItem(int index, bool value) async {
    final current = state.value;
    if (current == null) return;
    final updatedItems = [...current.items];
    updatedItems[index] = updatedItems[index].copyWith(isChecked: value);
    final updated = current.copyWith(items: updatedItems);
    state = AsyncValue.data(updated);
    await _repo.updateLatest(updated);
  }
}

