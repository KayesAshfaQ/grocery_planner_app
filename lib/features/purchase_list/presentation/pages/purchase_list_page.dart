import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/widgets/purchase_list_card.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/context_menu.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/confirmation_dialog.dart';
import '../widgets/purchase_list_form_bottom_sheet.dart';
import 'purchase_list_editor_page.dart';

import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  /// Route path for this page
  static const String routePath = '/purchase-list';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create() {
    return BlocProvider(
      create: (context) =>
          sl<PurchaseListBloc>()..add(GetAllPurchaseItemsEvent()),
      child: const PurchaseListPage(),
    );
  }

  @override
  State<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage>
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
      appBar: AppBar(
        title: Text('Purchase List'),
        elevation: 0,
      ),
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
          PurchaseListFormBottomSheet.showAdd(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PurchaseListContent extends StatelessWidget {
  final bool isPurchased;

  const _PurchaseListContent({required this.isPurchased});

  void _showEditBottomSheet(BuildContext context, PurchaseList list) {
    PurchaseListFormBottomSheet.showEdit(context, list);
  }

  void _showDeleteConfirmation(BuildContext context, PurchaseList list) async {
    // Capture bloc before async call
    final bloc = context.read<PurchaseListBloc>();

    final shouldDelete = await ConfirmationDialog.show(
      context,
      title: 'Delete List',
      content: 'Are you sure you want to delete "${list.name}"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldDelete == true) {
      bloc.add(
        RemovePurchaseListEvent(id: list.id!),
      );
    }
  }

  void _togglePurchaseStatus(BuildContext context, PurchaseList list) {
    final updatedList =
        list.copyWith(isCompleted: !(list.isCompleted ?? false));
    context.read<PurchaseListBloc>().add(
          UpdatePurchaseListEvent(item: updatedList),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseListBloc, PurchaseListState>(
        builder: (context, state) {
      if (state is PurchaseListLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is PurchaseListLoadedState) {
        final items = state.items
            .where((item) => item.isCompleted == isPurchased)
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
            final listItem = items[index];
            return ContextMenu(
              items: [
                ContextMenuItem(
                  label: 'Edit',
                  icon: Icons.edit,
                  onTap: () => _showEditBottomSheet(context, listItem),
                ),
                ContextMenuItem(
                  label: 'Delete',
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () => _showDeleteConfirmation(context, listItem),
                ),
                ContextMenuItem(
                  label: isPurchased ? 'Mark as To Buy' : 'Mark as Purchased',
                  icon: isPurchased ? Icons.shopping_cart : Icons.check,
                  onTap: () => _togglePurchaseStatus(context, listItem),
                ),
              ],
              child: PurchaseListCard(
                purchaseList: listItem,
                onPressed: () {
                  // Navigate to the purchase list details page
                  context.go(
                    '${PurchaseListPage.routePath}/${PurchaseListEditorPage.routePath}/${listItem.id}',
                  );
                },
              ),
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
                  context
                      .read<PurchaseListBloc>()
                      .add(GetAllPurchaseItemsEvent());
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
