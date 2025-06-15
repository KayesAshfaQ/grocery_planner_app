import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatelessWidget {
  /// Route path for this page
  static const String routePath = '/';

  final StatefulNavigationShell navigationShell;

  const Dashboard({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  // List of icons for the bottom navigation
  static const List<IconData> _navigationIcons = [
    Icons.shopping_cart,
    Icons.store,
    Icons.category,
    Icons.calendar_today,
    Icons.bar_chart,
  ];

  // List of labels for the bottom navigation
  static const List<String> _navigationLabels = [
    'Grocery List',
    'Catalog',
    'Category',
    'Schedule',
    'Reports',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: List.generate(
          _navigationLabels.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_navigationIcons[index]),
            label: _navigationLabels[index],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // Only navigate if the tab is not already selected
    if (index != navigationShell.currentIndex) {
      navigationShell.goBranch(
        index,
        // A common pattern when using bottom navigation bars is to support
        // navigating to the initial location when tapping the item that is
        // already active. This example demonstrates how to support this behavior,
        // using the initialLocation parameter of goBranch.
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }
}
