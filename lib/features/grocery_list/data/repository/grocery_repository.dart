import 'dart:math';

import '../../../../core/api/gemini_service.dart';
import '../../../../core/storage/local_db.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/json_parser.dart';
import '../../../meal_plan/data/models/meal_plan_model.dart';
import '../models/grocery_item_model.dart';
import '../models/grocery_list_model.dart';

final class GroceryRepository {
  final GeminiService _ai;
  final LocalDb _db;

  GroceryRepository(this._ai, this._db);

  MealPlanModel? getLatestMealPlan() {
    final json = _db.getLatestMealPlan();
    if (json == null) return null;
    try {
      return MealPlanModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<GroceryListModel> generateFromMealPlanAndSave(MealPlanModel plan) async {
    try {
      final prompt = _buildPrompt(plan);
      final text = await _ai.generateJsonText(userPrompt: prompt);
      final json = JsonParser.parseJsonObjectFromText(text);

      final now = DateTime.now();
      final list = GroceryListModel.fromJson({
        ...json,
        'id': _id(),
        'created_at': now.toIso8601String(),
      });

      // гарантируем поля is_checked
      final normalized = list.copyWith(
        items: list.items
            .map((i) => GroceryItemModel(item: i.item, quantity: i.quantity, isChecked: false))
            .toList(),
      );

      await _db.saveGroceryList({
        ...normalized.toJson(),
      });
      return normalized;
    } catch (e) {
      throw ErrorHandler.toAppError(e);
    }
  }

  Future<void> updateLatest(GroceryListModel list) async {
    try {
      await _db.updateLatestGroceryList(list.toJson());
    } catch (e) {
      throw ErrorHandler.toAppError(e);
    }
  }

  static String _id() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return List.generate(12, (_) => chars[r.nextInt(chars.length)]).join();
  }

  String _buildPrompt(MealPlanModel plan) {
    return '''
По этому JSON плана питания на неделю составь список покупок с количествами на русском языке.
Верни ТОЛЬКО JSON строго по этой схеме:
{
  "grocery_list": [
    {"item":"куриная грудка","quantity":"1 кг"},
    {"item":"рис","quantity":"500 г"}
  ]
}

JSON плана питания:
${plan.toJson()}
''';
  }
}

