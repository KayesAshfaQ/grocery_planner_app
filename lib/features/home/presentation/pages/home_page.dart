import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_planner_app/features/analytics/presentation/pages/analytics_page.dart';
import 'package:grocery_planner_app/features/catalog/presentation/pages/catalog_page.dart';
import 'package:grocery_planner_app/features/grocery_list/presentation/pages/grocery_list_page.dart';
import 'package:grocery_planner_app/features/home/presentation/cubits/navigation_cubit.dart';
import 'package:grocery_planner_app/features/schedule/presentation/pages/schedule_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  final List<Widget> _pages = const [
    GroceryListPage(),
    CatalogPage(),
    SchedulePage(),
    AnalyticsPage(),
  ];

  final List<String> _titles = const [
    'Grocery List',
    'Catalog',
    'Schedule',
    'Analytics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) => Text(_titles[state]),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) => PageView(
          controller: PageController(initialPage: state),
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: state,
          onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Grocery List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}
