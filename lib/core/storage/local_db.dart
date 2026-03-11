import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final class LocalDb {
  static const _kMealPlans = 'meal_plans';
  static const _kRecipes = 'recipes';
  static const _kGroceryLists = 'grocery_lists';

  final SharedPreferences _prefs;
  LocalDb(this._prefs);

  static Future<LocalDb> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalDb(prefs);
  }

  List<Map<String, dynamic>> getMealPlans() => _getList(_kMealPlans);
  List<Map<String, dynamic>> getRecipes() => _getList(_kRecipes);
  List<Map<String, dynamic>> getGroceryLists() => _getList(_kGroceryLists);

  Future<void> saveMealPlan(Map<String, dynamic> json) async =>
      _appendToList(_kMealPlans, json);
  Future<void> saveRecipe(Map<String, dynamic> json) async =>
      _appendToList(_kRecipes, json);
  Future<void> saveGroceryList(Map<String, dynamic> json) async =>
      _appendToList(_kGroceryLists, json);

  Map<String, dynamic>? getLatestMealPlan() {
    final list = getMealPlans();
    if (list.isEmpty) return null;
    return list.first;
  }

  Future<void> updateLatestGroceryList(Map<String, dynamic> json) async {
    final list = _getList(_kGroceryLists);
    if (list.isEmpty) {
      await _appendToList(_kGroceryLists, json);
      return;
    }
    list[0] = json;
    await _setList(_kGroceryLists, list);
  }

  List<Map<String, dynamic>> _getList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.trim().isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
  }

  Future<void> _appendToList(String key, Map<String, dynamic> json) async {
    final list = _getList(key);
    list.insert(0, json);
    await _setList(key, list);
  }

  Future<void> _setList(String key, List<Map<String, dynamic>> list) async {
    await _prefs.setString(key, jsonEncode(list));
  }

  Future<void> clearAppData() async {
    await _prefs.remove(_kMealPlans);
    await _prefs.remove(_kRecipes);
    await _prefs.remove(_kGroceryLists);
  }
}

