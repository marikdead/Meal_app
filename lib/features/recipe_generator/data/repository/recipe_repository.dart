import 'dart:math';

import '../../../../core/api/gemini_service.dart';
import '../../../../core/storage/local_db.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/json_parser.dart';
import '../models/recipe_model.dart';

final class RecipeRepository {
  final GeminiService _ai;
  final LocalDb _db;

  RecipeRepository(this._ai, this._db);

  Future<List<RecipeModel>> generateAndSave({required List<String> ingredients}) async {
    try {
      final prompt = _buildPrompt(ingredients);
      final text = await _ai.generateJsonText(userPrompt: prompt);
      final json = JsonParser.parseJsonObjectFromText(text);

      final recipes = (json['recipes'] as List?) ?? const [];
      final parsed = recipes.whereType<Map>().map((e) {
        final m = e.cast<String, dynamic>();
        final model = RecipeModel.fromJson({
          ...m,
          'id': _id(),
        });
        return model;
      }).toList();

      for (final r in parsed) {
        await _db.saveRecipe(r.toJson());
      }
      return parsed;
    } catch (e) {
      throw ErrorHandler.toAppError(e);
    }
  }

  static String _id() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return List.generate(12, (_) => chars[r.nextInt(chars.length)]).join();
  }

  String _buildPrompt(List<String> ingredients) {
    final list = ingredients.join(', ');
    return '''
Создай 3 рецепта на русском языке, используя только эти ингредиенты (можно добавить базовые продукты вроде соли/перца/масла).
Ингредиенты: $list

Верни ТОЛЬКО JSON строго по этой схеме:
{
  "recipes": [
    {
      "name": "...",
      "calories": 540,
      "ingredients": ["..."],
      "steps": ["..."]
    }
  ]
}

Требования к содержимому:
- name, ingredients и steps должны быть на русском.
''';
  }
}

