import 'package:flutter/material.dart';

import '../../data/models/meal_day_model.dart';
import '../../data/models/meal_entry_model.dart';

class MealDayDetailsScreen extends StatelessWidget {
  final MealDayModel day;

  const MealDayDetailsScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(day.day)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DaySummary(day: day),
          const SizedBox(height: 12),
          _MealSection(title: 'Завтрак', meal: day.breakfast),
          const SizedBox(height: 12),
          _MealSection(title: 'Обед', meal: day.lunch),
          const SizedBox(height: 12),
          _MealSection(title: 'Ужин', meal: day.dinner),
        ],
      ),
    );
  }
}

class _DaySummary extends StatelessWidget {
  final MealDayModel day;
  const _DaySummary({required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Итого за день',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text('${day.totalCalories} ккал', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final String title;
  final MealEntryModel meal;

  const _MealSection({required this.title, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(title),
        subtitle: Text(meal.name.isEmpty ? '—' : meal.name),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          _Nutrition(meal: meal),
          const SizedBox(height: 12),
          _Recipe(meal: meal),
        ],
      ),
    );
  }
}

class _Nutrition extends StatelessWidget {
  final MealEntryModel meal;
  const _Nutrition({required this.meal});

  @override
  Widget build(BuildContext context) {
    final n = meal.nutrition;
    if (n == null) {
      return const Text('КБЖУ: нет данных (обновите план, чтобы получить расширенную версию).');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('КБЖУ', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _Chip(label: '${n.calories} ккал'),
            _Chip(label: 'Б ${_fmt(n.proteinG)} г'),
            _Chip(label: 'Ж ${_fmt(n.fatG)} г'),
            _Chip(label: 'У ${_fmt(n.carbsG)} г'),
          ],
        ),
      ],
    );
  }

  String _fmt(num v) {
    final r = v.round();
    if ((v - r).abs() < 0.0001) return r.toString();
    return v.toStringAsFixed(1);
  }
}

class _Recipe extends StatelessWidget {
  final MealEntryModel meal;
  const _Recipe({required this.meal});

  @override
  Widget build(BuildContext context) {
    final r = meal.recipe;
    if (r == null) {
      return const Text('Рецепт: нет данных (обновите план, чтобы получить расширенную версию).');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Рецепт', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('Ингредиенты', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        if (r.ingredients.isEmpty) const Text('—') else ...r.ingredients.map((i) => Text('• $i')),
        const SizedBox(height: 12),
        Text('Шаги', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        if (r.steps.isEmpty) const Text('—') else ...r.steps.asMap().entries.map((e) => Text('${e.key + 1}. ${e.value}')),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

