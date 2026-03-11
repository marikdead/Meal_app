import 'package:flutter/material.dart';

class MealPlanForm extends StatefulWidget {
  final void Function({
    required String goal,
    required int calories,
    required List<String> dietRestrictions,
    required List<String> allergies,
  }) onSubmit;

  final bool isLoading;

  const MealPlanForm({super.key, required this.onSubmit, required this.isLoading});

  @override
  State<MealPlanForm> createState() => _MealPlanFormState();
}

class _MealPlanFormState extends State<MealPlanForm> {
  final _caloriesController = TextEditingController(text: '2000');
  String _goal = 'health';
  final _diet = <String>{};
  final _allergyController = TextEditingController();
  final _allergies = <String>{};

  @override
  void dispose() {
    _caloriesController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  void _addAllergyFromField() {
    final value = _allergyController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _allergies.add(value);
      _allergyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _goal,
          decoration: const InputDecoration(labelText: 'Цель'),
          items: const [
            DropdownMenuItem(value: 'weight_loss', child: Text('Похудение')),
            DropdownMenuItem(value: 'muscle_gain', child: Text('Набор массы')),
            DropdownMenuItem(value: 'health', child: Text('Здоровье')),
          ],
          onChanged: widget.isLoading ? null : (v) => setState(() => _goal = v ?? 'health'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _caloriesController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Калорий в день'),
          enabled: !widget.isLoading,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip('vegan', 'Веган'),
            _chip('vegetarian', 'Вегетарианец'),
            _chip('gluten_free', 'Без глютена'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _allergyController,
                decoration: const InputDecoration(
                  labelText: 'Аллергены',
                  hintText: 'Добавьте аллерген и нажмите «+»',
                ),
                enabled: !widget.isLoading,
                textInputAction: TextInputAction.done,
                onSubmitted: widget.isLoading ? null : (_) => _addAllergyFromField(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: widget.isLoading ? null : _addAllergyFromField,
              icon: const Icon(Icons.add),
              tooltip: 'Добавить',
            ),
          ],
        ),
        if (_allergies.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allergies
                .map(
                  (a) => InputChip(
                    label: Text(a),
                    onDeleted: widget.isLoading ? null : () => setState(() => _allergies.remove(a)),
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: widget.isLoading
              ? null
              : () {
                  _addAllergyFromField();
                  final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
                  widget.onSubmit(
                    goal: _goal,
                    calories: calories,
                    dietRestrictions: _diet.toList(),
                    allergies: _allergies.toList(),
                  );
                },
          child: widget.isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Сгенерировать'),
        ),
      ],
    );
  }

  Widget _chip(String value, String label) {
    final selected = _diet.contains(value);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: widget.isLoading
          ? null
          : (v) {
              setState(() {
                if (v) {
                  _diet.add(value);
                } else {
                  _diet.remove(value);
                }
              });
            },
    );
  }
}

