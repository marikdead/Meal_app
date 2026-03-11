import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_error_widget.dart';
import '../../data/models/grocery_list_model.dart';
import '../providers/grocery_provider.dart';
import '../widgets/grocery_item_tile.dart';

class GroceryScreen extends ConsumerWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groceryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Список покупок')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(groceryProvider.notifier).generateFromLatestMealPlan(),
              child: state.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Сгенерировать из плана питания'),
            ),
            const SizedBox(height: 16),
            _Result(state: state),
          ],
        ),
      ),
    );
  }
}

class _Result extends ConsumerWidget {
  final AsyncValue<GroceryListModel?> state;
  const _Result({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
      error: (e, _) => AppErrorWidget(message: e.toString()),
      data: (list) {
        if (list == null) return const Text('Список покупок пока не создан.');
        if (list.items.isEmpty) return const Text('Список пуст.');
        return Column(
          children: [
            ...list.items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return GroceryItemTile(
                item: item,
                onChanged: (v) {
                  ref.read(groceryProvider.notifier).toggleItem(idx, v ?? false);
                },
              );
            }),
          ],
        );
      },
    );
  }
}

