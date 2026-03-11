import 'package:flutter/material.dart';

import '../../features/grocery_list/presentation/screens/grocery_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/meal_plan/presentation/screens/meal_plan_screen.dart';
import '../../features/recipe_generator/presentation/screens/recipe_screen.dart';

final class AppRoutes {
  static const home = '/';
  static const mealPlan = '/meal-plan';
  static const recipes = '/recipes';
  static const grocery = '/grocery';
}

final class AppRouter {
  static final routes = <String, WidgetBuilder>{
    AppRoutes.home: (_) => const HomeScreen(),
    AppRoutes.mealPlan: (_) => const MealPlanScreen(),
    AppRoutes.recipes: (_) => const RecipeScreen(),
    AppRoutes.grocery: (_) => const GroceryScreen(),
  };
}

