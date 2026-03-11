final class MealNutritionModel {
  final int calories;
  final num proteinG;
  final num fatG;
  final num carbsG;

  const MealNutritionModel({
    required this.calories,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
  });

  factory MealNutritionModel.fromJson(Map<String, dynamic> json) {
    return MealNutritionModel(
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinG: (json['protein_g'] as num?) ?? 0,
      fatG: (json['fat_g'] as num?) ?? 0,
      carbsG: (json['carbs_g'] as num?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein_g': proteinG,
        'fat_g': fatG,
        'carbs_g': carbsG,
      };
}

final class MealRecipeModel {
  final List<String> ingredients;
  final List<String> steps;

  const MealRecipeModel({
    required this.ingredients,
    required this.steps,
  });

  factory MealRecipeModel.fromJson(Map<String, dynamic> json) {
    return MealRecipeModel(
      ingredients: (json['ingredients'] as List?)?.whereType<String>().toList() ?? const [],
      steps: (json['steps'] as List?)?.whereType<String>().toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'ingredients': ingredients,
        'steps': steps,
      };
}

final class MealEntryModel {
  final String name;
  final MealNutritionModel? nutrition;
  final MealRecipeModel? recipe;

  const MealEntryModel({
    required this.name,
    this.nutrition,
    this.recipe,
  });

  factory MealEntryModel.fromAny(dynamic value) {
    if (value is String) {
      return MealEntryModel(name: value);
    }
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      final n = json['nutrition'];
      final r = json['recipe'];
      return MealEntryModel(
        name: (json['name'] as String?) ?? '',
        nutrition: n is Map ? MealNutritionModel.fromJson(n.cast<String, dynamic>()) : null,
        recipe: r is Map ? MealRecipeModel.fromJson(r.cast<String, dynamic>()) : null,
      );
    }
    return const MealEntryModel(name: '');
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (nutrition != null) 'nutrition': nutrition!.toJson(),
        if (recipe != null) 'recipe': recipe!.toJson(),
      };
}

