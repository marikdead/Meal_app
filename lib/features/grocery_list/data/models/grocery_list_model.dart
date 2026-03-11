import 'grocery_item_model.dart';

final class GroceryListModel {
  final String id;
  final DateTime createdAt;
  final List<GroceryItemModel> items;

  const GroceryListModel({
    required this.id,
    required this.createdAt,
    required this.items,
  });

  factory GroceryListModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['grocery_list'] as List?) ?? (json['items'] as List?) ?? const [];
    return GroceryListModel(
      id: (json['id'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ?? DateTime.now(),
      items: raw
          .whereType<Map>()
          .map((e) => GroceryItemModel.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
      };

  GroceryListModel copyWith({List<GroceryItemModel>? items}) => GroceryListModel(
        id: id,
        createdAt: createdAt,
        items: items ?? this.items,
      );
}

