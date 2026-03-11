import 'package:flutter/material.dart';

import '../../data/models/grocery_item_model.dart';

class GroceryItemTile extends StatelessWidget {
  final GroceryItemModel item;
  final ValueChanged<bool?> onChanged;

  const GroceryItemTile({super.key, required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: item.isChecked,
      onChanged: onChanged,
      title: Text(item.item),
      subtitle: Text(item.quantity),
    );
  }
}

