import 'meal_day_model.dart';

final class MealPlanModel {
  final String id;
  final DateTime createdAt;
  final String goal;
  final int calories;
  final List<String> dietRestrictions;
  final List<String> allergies;
  final List<MealDayModel> weekPlan;

  const MealPlanModel({
    required this.id,
    required this.createdAt,
    required this.goal,
    required this.calories,
    required this.dietRestrictions,
    required this.allergies,
    required this.weekPlan,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    final week = (json['week_plan'] as List?) ?? const [];
    return MealPlanModel(
      id: (json['id'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ?? DateTime.now(),
      goal: (json['goal'] as String?) ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      dietRestrictions:
          (json['diet_restrictions'] as List?)?.whereType<String>().toList() ?? const [],
      allergies: (json['allergies'] as List?)?.whereType<String>().toList() ?? const [],
      weekPlan: week.whereType<Map>().map((e) => MealDayModel.fromJson(e.cast<String, dynamic>())).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'goal': goal,
        'calories': calories,
        'diet_restrictions': dietRestrictions,
        'allergies': allergies,
        'week_plan': weekPlan.map((e) => e.toJson()).toList(),
      };
}

