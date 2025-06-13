import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/pages/purchase_list_editor_page.dart';
import 'package:grocery_planner_app/features/dashboard/presentation/widgets/purchase_list_card.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  /// Route path for this page
  static const String routePath = '/purchase-list';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create() {
    return BlocProvider(
      create: (context) => sl<PurchaseListBloc>()..add(GetAllPurchaseItemsEvent()),
      child: const PurchaseListPage(),
    );
  }

  @override
  State<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> with SingleTickerProviderStateMixin {
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
            tabs: const [
              Tab(text: 'To Buy'),
              Tab(text: 'Purchased'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _PurchaseListContent(isPurchased: false),
                _PurchaseListContent(isPurchased: true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Updated to use route constants from the respective page files
          context.go(
            '${PurchaseListPage.routePath}/${PurchaseListEditorPage.routePath}',
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PurchaseListContent extends StatelessWidget {
  final bool isPurchased;

  const _PurchaseListContent({required this.isPurchased});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseListBloc, PurchaseListState>(builder: (context, state) {
      if (state is PurchaseListLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is PurchaseListLoadedState) {
        final items = state.items.where((item) => item.isCompleted == isPurchased).toList();
        if (items.isEmpty) {
          return Center(
            child: Text(
              isPurchased ? 'No purchased items yet' : 'No items to buy yet. Add some!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final listItem = items[index];
            return PurchaseListCard(
              purchaseList: listItem,
            );
          },
        );
      } else if (state is PurchaseListErrorState) {
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
                  context.read<PurchaseListBloc>().add(GetAllPurchaseItemsEvent());
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
