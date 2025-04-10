import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/config/routes/app_router.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/home/presentation/blocs/grocery/grocery_bloc.dart';
import 'package:grocery_planner_app/features/home/presentation/widgets/grocery_item_card.dart';

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
    return BlocProvider(
      create: (context) => sl<GroceryBloc>()..add(GetAllGroceryItemsEvent()),
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'To Buy'),
                Tab(text: 'Purchased'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _GroceryListContent(isPurchased: false),
                  _GroceryListContent(isPurchased: true),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AppRouter.groceryItemEditor).then((_) {
              // Refresh the list when returning from add page
              if (_tabController.index == 0) {
                context.read<GroceryBloc>().add(
                    const GetGroceryItemsByStatusEvent(isPurchased: false));
              } else {
                context
                    .read<GroceryBloc>()
                    .add(const GetGroceryItemsByStatusEvent(isPurchased: true));
              }
            });
          },
          tooltip: 'Add Item',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _GroceryListContent extends StatelessWidget {
  final bool isPurchased;

  const _GroceryListContent({required this.isPurchased});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroceryBloc, GroceryState>(builder: (context, state) {
      if (state is GroceryLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is GroceryLoadedState) {
        final items = state.items
            .where((item) => item.isPurchased == isPurchased)
            .toList();
        if (items.isEmpty) {
          return Center(
            child: Text(
              isPurchased
                  ? 'No purchased items yet'
                  : 'No items to buy yet. Add some!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GroceryItemCard(
              groceryItem: item,
            );
          },
        );
      } else if (state is GroceryErrorState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.message}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<GroceryBloc>().add(GetAllGroceryItemsEvent());
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }

      return const Center(child: Text('No items found'));
    });
  }
}
