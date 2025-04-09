import 'package:flutter/material.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            // labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'To Buy'),
              Tab(text: 'Purchased'),
            ],
            onTap: (index) {
              //TODO: Handle tab change
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('To Buy')),
                Center(child: Text('Purchased')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
