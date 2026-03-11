final class RecipeModel {
  final String id;
  final String name;
  final int calories;
  final List<String> ingredients;
  final List<String> steps;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      ingredients: (json['ingredients'] as List?)?.whereType<String>().toList() ?? const [],
      steps: (json['steps'] as List?)?.whereType<String>().toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'ingredients': ingredients,
        'steps': steps,
      };
}

