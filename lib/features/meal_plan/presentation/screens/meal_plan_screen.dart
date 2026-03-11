import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_error_widget.dart';
import '../../data/models/meal_plan_model.dart';
import '../providers/meal_plan_provider.dart';
import '../widgets/meal_plan_card.dart';
import '../widgets/meal_plan_form.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  @override
  void initState() {
    super.initState();
    // подгружаем последний сохранённый план
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlanProvider.notifier).loadLatest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealPlanProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('План питания')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            MealPlanForm(
              isLoading: state.isLoading,
              onSubmit: ({required goal, required calories, required dietRestrictions, required allergies}) {
                ref.read(mealPlanProvider.notifier).generate(
                      goal: goal,
                      calories: calories,
                      dietRestrictions: dietRestrictions,
                      allergies: allergies,
                    );
              },
            ),
            const SizedBox(height: 16),
            _Result(state: state),
          ],
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  final AsyncValue<MealPlanModel?> state;
  const _Result({required this.state});

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
      error: (e, _) => AppErrorWidget(message: e.toString()),
      data: (plan) {
        if (plan == null) {
          return const Text('Плана пока нет. Сгенерируйте новый.');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цель: ${_goalLabel(plan.goal)} • Калории: ${plan.calories}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...plan.weekPlan.map((d) => MealPlanCard(day: d)),
          ],
        );
      },
    );
  }

  String _goalLabel(String goal) {
    switch (goal) {
      case 'weight_loss':
        return 'Похудение';
      case 'muscle_gain':
        return 'Набор массы';
      case 'health':
        return 'Здоровье';
      default:
        return goal;
    }
  }
}

