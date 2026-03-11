final class GroceryItemModel {
  final String item;
  final String quantity;
  final bool isChecked;

  const GroceryItemModel({
    required this.item,
    required this.quantity,
    required this.isChecked,
  });

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      item: (json['item'] as String?) ?? '',
      quantity: (json['quantity'] as String?) ?? '',
      isChecked: (json['is_checked'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'item': item,
        'quantity': quantity,
        'is_checked': isChecked,
      };

  GroceryItemModel copyWith({bool? isChecked}) => GroceryItemModel(
        item: item,
        quantity: quantity,
        isChecked: isChecked ?? this.isChecked,
      );
}

