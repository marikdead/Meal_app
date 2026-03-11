import 'dart:math';

import '../../../../core/api/gemini_service.dart';
import '../../../../core/storage/local_db.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/json_parser.dart';
import '../models/meal_plan_model.dart';

final class MealPlanRepository {
  final GeminiService _ai;
  final LocalDb _db;

  MealPlanRepository(this._ai, this._db);

  Future<MealPlanModel> generateAndSave({
    required String goal,
    required int calories,
    required List<String> dietRestrictions,
    required List<String> allergies,
  }) async {
    try {
      final prompt = _buildPrompt(
        goal: goal,
        calories: calories,
        dietRestrictions: dietRestrictions,
        allergies: allergies,
      );
      final text = await _ai.generateJsonText(userPrompt: prompt);
      final json = JsonParser.parseJsonObjectFromText(text);

      final now = DateTime.now();
      final model = MealPlanModel.fromJson({
        ...json,
        'id': _id(),
        'created_at': now.toIso8601String(),
        'goal': goal,
        'calories': calories,
        'diet_restrictions': dietRestrictions,
        'allergies': allergies,
      });

      await _db.saveMealPlan(model.toJson());
      return model;
    } catch (e) {
      throw ErrorHandler.toAppError(e);
    }
  }

  MealPlanModel? getLatest() {
    final json = _db.getLatestMealPlan();
    if (json == null) return null;
    try {
      return MealPlanModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static String _id() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return List.generate(12, (_) => chars[r.nextInt(chars.length)]).join();
  }

  String _buildPrompt({
    required String goal,
    required int calories,
    required List<String> dietRestrictions,
    required List<String> allergies,
  }) {
    final diet = dietRestrictions.isEmpty ? 'нет' : dietRestrictions.join(', ');
    final all = allergies.isEmpty ? 'нет' : allergies.join(', ');
    return '''
Сгенерируй план питания на 7 дней на русском языке.

Ограничения:
- Цель: $goal
- Целевая калорийность в день: $calories
- Ограничения по диете: $diet
- Аллергены: $all

Верни ТОЛЬКО JSON строго по этой схеме:
{
  "week_plan": [
    {
      "day": "Понедельник",
      "meals": {
        "breakfast": {
          "name": "...",
          "nutrition": { "calories": 500, "protein_g": 30, "fat_g": 15, "carbs_g": 55 },
          "recipe": { "ingredients": ["..."], "steps": ["..."] }
        },
        "lunch": {
          "name": "...",
          "nutrition": { "calories": 700, "protein_g": 45, "fat_g": 20, "carbs_g": 80 },
          "recipe": { "ingredients": ["..."], "steps": ["..."] }
        },
        "dinner": {
          "name": "...",
          "nutrition": { "calories": 650, "protein_g": 40, "fat_g": 22, "carbs_g": 65 },
          "recipe": { "ingredients": ["..."], "steps": ["..."] }
        }
      },
      "total_calories": 2000
    }
  ]
}

Требования к содержимому:
- meals.breakfast/lunch/dinner должны быть объектами по схеме выше.
- name, ingredients и steps должны быть на русском.
- КБЖУ укажи примерно, но реалистично (граммы — числа).
- day должен быть на русском.
''';
  }
}

