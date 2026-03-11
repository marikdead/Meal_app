import 'package:flutter/material.dart';

import '../../data/models/meal_day_model.dart';
import '../screens/meal_day_details_screen.dart';

class MealPlanCard extends StatelessWidget {
  final MealDayModel day;

  const MealPlanCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MealDayDetailsScreen(day: day)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(day.day, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text('Завтрак: ${day.breakfast.name}'),
              Text('Обед: ${day.lunch.name}'),
              Text('Ужин: ${day.dinner.name}'),
              const SizedBox(height: 8),
              Text('Всего калорий: ${day.totalCalories}'),
            ],
          ),
        ),
      ),
    );
  }
}

