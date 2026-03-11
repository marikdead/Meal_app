import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../shared/router/app_router.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../grocery_list/presentation/providers/grocery_provider.dart';
import '../../meal_plan/presentation/providers/meal_plan_provider.dart';
import '../../recipe_generator/presentation/providers/recipe_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Планировщик питания'),
        actions: [
          IconButton(
            tooltip: 'Очистить данные приложения',
            icon: const Icon(Icons.delete_forever_outlined),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Очистить данные?'),
                  content: const Text('Будут удалены сохранённые планы питания, рецепты и списки покупок.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Отмена'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Очистить'),
                    ),
                  ],
                ),
              );

              if (confirmed != true) return;

              await ref.read(localDbProvider).clearAppData();
              ref.invalidate(mealPlanProvider);
              ref.invalidate(recipeProvider);
              ref.invalidate(groceryProvider);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Данные приложения очищены')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
              label: 'Сгенерировать план питания',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.mealPlan),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Сгенерировать рецепт',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.recipes),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Список покупок',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.grocery),
            ),
            const Spacer(),
            Text(
              'Ключ Gemini сейчас вшит в приложение (для MVP).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

