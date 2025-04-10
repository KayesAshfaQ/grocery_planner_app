import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_planner_app/features/home/presentation/pages/analytics_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/catalog_page.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/grocery_list_page.dart';
import 'package:grocery_planner_app/features/home/presentation/cubits/navigation_cubit.dart';
import 'package:grocery_planner_app/features/home/presentation/pages/schedule_page.dart';

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

class _HomePageView extends StatefulWidget {
  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  late final PageController _pageController;

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
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) => Text(_titles[state]),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<NavigationCubit, int>(
        listener: (context, state) {
          _pageController.jumpToPage(state);
        },
        builder: (context, state) => PageView(
          controller: _pageController,
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
