import 'meal_entry_model.dart';

final class MealDayModel {
  final String day;
  final MealEntryModel breakfast;
  final MealEntryModel lunch;
  final MealEntryModel dinner;
  final int totalCalories;

  const MealDayModel({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.totalCalories,
  });

  factory MealDayModel.fromJson(Map<String, dynamic> json) {
    final meals = (json['meals'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    return MealDayModel(
      day: (json['day'] as String?) ?? '',
      breakfast: MealEntryModel.fromAny(meals['breakfast']),
      lunch: MealEntryModel.fromAny(meals['lunch']),
      dinner: MealEntryModel.fromAny(meals['dinner']),
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'meals': {
          'breakfast': breakfast.toJson(),
          'lunch': lunch.toJson(),
          'dinner': dinner.toJson(),
        },
        'total_calories': totalCalories,
      };
}

