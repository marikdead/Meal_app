import 'package:flutter/material.dart';
import 'core/att/att_service.dart';
import 'shared/widgets/ads_widgets.dart';
import 'features/grocery_list/presentation/screens/grocery_screen.dart';
import 'features/meal_plan/presentation/screens/meal_plan_screen.dart';
import 'features/recipe_generator/presentation/screens/recipe_screen.dart';

/// Основной экран с нижней навигацией и баннерной рекламой.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    // После первого кадра запрашиваем ATT через Flutter-сервис.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AttService.requestIfNeeded(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const RecipeScreen(),          // левая вкладка
      const MealPlanScreen(),      // центральная (зелёная кнопка)
      const GroceryScreen(),       // правая вкладка
    ];

    return Scaffold(
      extendBody: true,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [ // баннер всегда сверху и не перекрывается
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FloatingActionButton(
          backgroundColor: Colors.teal,
          shape: const CircleBorder(),
          onPressed: () {
            if (_currentIndex == 1) return;
            setState(() {
              _currentIndex = 1;
            });
            AdManager.showInterstitial();
          },
          child: const Icon(
            Icons.restaurant_menu,
            size: 32,
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AdBannerWidget(),
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentIndex == 0) return;
                      setState(() {
                        _currentIndex = 0;
                      });
                      AdManager.showInterstitial();
                    },
                    icon: Icon(
                      Icons.list_alt,
                      color:
                          _currentIndex == 0 ? Colors.teal : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 48), // место под центральную круглую кнопку
                  IconButton(
                    onPressed: () {
                      if (_currentIndex == 2) return;
                      setState(() {
                        _currentIndex = 2;
                      });
                      AdManager.showInterstitial();
                    },
                    icon: Icon(
                      Icons.person,
                      color:
                          _currentIndex == 2 ? Colors.teal : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SimplePage({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

