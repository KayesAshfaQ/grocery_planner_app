import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/core/extensions/datetime_extension.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_item.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/toast/app_toast.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/widgets/add_item_bottom_sheet.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/widgets/quantity_update_bottom_sheet.dart';

/// Page for adding a new grocery item
class PurchaseListEditorPage extends StatefulWidget {
  /// Creates a new add grocery item page
  const PurchaseListEditorPage({Key? key}) : super(key: key);

  /// Route path for this page (relative to parent)
  static const String routePath = 'editor';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create({required int id}) {
    return BlocProvider(
      create: (context) =>
          sl<PurchaseListEditorBloc>()..add(LoadInitialDataEvent(id: id)),
      child: const PurchaseListEditorPage(),
    );
  }

  @override
  State<PurchaseListEditorPage> createState() => _PurchaseListEditorPageState();
}

class _PurchaseListEditorPageState extends State<PurchaseListEditorPage> {
  // final _formKey = GlobalKey<FormState>();

  void _showAddItemBottomSheet(
    BuildContext context,
    int listId,
  ) {
    AddItemBottomSheet.show(context, listId: listId);
  }

  void _showQuantityUpdateBottomSheet(
    BuildContext context,
    PurchaseItem item,
  ) {
    QuantityUpdateBottomSheet.show(
      context,
      item: item,
      onUpdate: (updatedItem) {
        context.read<PurchaseListEditorBloc>().add(
              UpdatePurchaseListEvent(item: updatedItem),
            );
      },
    );
  }

  /* void _submitForm(BuildContext context, PurchaseListEditorLoadedState state) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final name = _nameController.text;
    final budget = double.tryParse(_budgetController.text) ?? 0.0;
    final currency = _currencyController.text;
    final note = _noteController.text;

    context.read<PurchaseListEditorBloc>().add(
          AddPurchaseListEvent(
            list: PurchaseList(
              name: name,
              budget: budget,
              currencySymbol: currency,
              note: note,
            ),
          ),
        );
  } */

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseListEditorBloc, PurchaseListEditorState>(
      listener: (context, state) {
        if (state is PurchaseListEditorErrorState) {
          AppToast.showError(context, state.message);
        }
        // Note: Success messages are now handled by the UI components that trigger the actions
        // This follows the efficient state management pattern where we don't need dedicated success states
      },
      builder: (context, state) {
        // Extract data based on state type
        PurchaseList? purchaseList;

        if (state is PurchaseListEditorLoadedState) {
          purchaseList = state.purchaseList;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Shopping List'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final loaded = state as PurchaseListEditorLoadedState;
              final listId = loaded.purchaseList?.id;
              if (listId != null) {
                _showAddItemBottomSheet(context, listId);
              }
            },
            tooltip: 'Add Item',
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, state, purchaseList),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PurchaseListEditorState? state,
      PurchaseList? purchaseList) {
    if (state is PurchaseListEditorLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle loaded state with efficient state management
    if (state is PurchaseListEditorLoadedState) {
      return _body(context, purchaseList);
    }

    // Fallback for initial state or error state
    return const Center(
      child: Text('Failed to load editor. Please try again.'),
    );
  }

  Widget _body(
    BuildContext context,
    PurchaseList? purchaseList,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // name of the list
          Text(
            purchaseList?.name != null && purchaseList!.name!.isNotEmpty
                ? purchaseList.name!
                : 'New Shopping List',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          // description of the list
          Text(
            purchaseList?.note != null && purchaseList!.note!.isNotEmpty
                ? purchaseList.note!
                : 'No description provided',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // date of the list
          Text(
            purchaseList?.createdAt != null
                ? 'Created ${purchaseList!.createdAt!.relativeTime}'
                : 'No date available',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),

          // budget of the list
          Text(
            purchaseList?.budget != null
                ? 'Budget: ${purchaseList!.budget} ${purchaseList.currencySymbol ?? 'USD'}'
                : 'No budget set',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          // Budget progress bar
          if (purchaseList?.budget != null && purchaseList!.budget! > 0) ...[
            Builder(
              builder: (context) {
                // Calculate total spent from items with unit prices
                final totalSpent = purchaseList.purchaseItems
                    .where((item) => item.unitPrice != null)
                    .fold<double>(0.0,
                        (sum, item) => sum + (item.unitPrice! * item.quantity));

                final budget = purchaseList.budget!;
                final progress = totalSpent / budget;
                final remainingBudget = budget - totalSpent;

                // Determine color based on budget usage
                Color progressColor;
                if (progress <= 0.5) {
                  progressColor = Colors.green;
                } else if (progress <= 0.8) {
                  progressColor = Colors.orange;
                } else {
                  progressColor = Colors.red;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining: ${remainingBudget.toStringAsFixed(2)} ${purchaseList.currencySymbol ?? 'USD'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            // fontSize: 12,
                            color: remainingBudget >= 0
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent: ${totalSpent.toStringAsFixed(2)} ${purchaseList.currencySymbol ?? 'USD'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: progressColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}% used',
                          style: TextStyle(
                            fontSize: 12,
                            color: progressColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                        minHeight: 8,
                      ),
                    ),
                    if (progress > 1.0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '⚠️ Over budget by ${(totalSpent - budget).toStringAsFixed(2)} ${purchaseList.currencySymbol ?? 'USD'}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],

          // -------------- Purchase Item Section --------------
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shopping Items',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (purchaseList?.purchaseItems.isNotEmpty == true) ...[
                Builder(
                  builder: (context) {
                    final items = purchaseList!.purchaseItems;
                    final completed =
                        items.where((item) => item.isPurchased).length;
                    final total = items.length;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: completed == total
                            ? Colors.green.withValues(alpha: 0.1)
                            : Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$completed/$total',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: completed == total
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: (purchaseList?.purchaseItems.isNotEmpty == true)
                  ? Builder(
                      builder: (context) {
                        // Sort items: unpurchased first, then purchased
                        final sortedItems =
                            List<PurchaseItem>.from(purchaseList!.purchaseItems)
                              ..sort((a, b) {
                                if (a.isPurchased == b.isPurchased) return 0;
                                return a.isPurchased
                                    ? 1
                                    : -1; // unpurchased items first
                              });

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedItems.length,
                          itemBuilder: (context, index) {
                            /// Get the purchase item at the current index
                            final item = sortedItems[index];

                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  final wasNotPurchased = !item.isPurchased;
                                  final updatedItem = item.copyWith(
                                    isPurchased: !item.isPurchased,
                                    purchasedAt: !item.isPurchased
                                        ? DateTime.now().toIso8601String()
                                        : null,
                                  );
                                  context.read<PurchaseListEditorBloc>().add(
                                        UpdatePurchaseListEvent(
                                            item: updatedItem),
                                      );

                                  // Show success feedback
                                  if (wasNotPurchased) {
                                    AppToast.showSuccess(context,
                                        '✓ ${item.customName ?? 'Item'} marked as purchased');
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: item.isPurchased == true
                                          ? Colors.green
                                          : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                    color: item.isPurchased == true
                                        ? Colors.green
                                        : Colors.transparent,
                                  ),
                                  child: item.isPurchased == true
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                              title: Text(
                                item.customName ??
                                    'Item #${item.catalogId ?? 'N/A'}',
                                style: TextStyle(
                                  decoration: item.isPurchased == true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: item.isPurchased == true
                                      ? Colors.grey
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                '${item.quantity} pc - ${item.unitPrice != null ? '\$${item.unitPrice}' : 'No price set'}',
                                style: TextStyle(
                                  color: item.isPurchased == true
                                      ? Colors.grey
                                      : null,
                                ),
                              ),
                              trailing: item.isPurchased
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () {
                                        if (item.id != null) {
                                          context
                                              .read<PurchaseListEditorBloc>()
                                              .add(
                                                RemoveItemFromPurchaseListEvent(
                                                    id: item.id!),
                                              );
                                        }
                                      },
                                    ),
                              // Disable editing for purchased items
                              onTap: item.isPurchased
                                  ? null
                                  : () {
                                      _showQuantityUpdateBottomSheet(
                                          context, item);
                                    },
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No items in your shopping list yet.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the ➕ button to add items from your catalog.',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'List Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a list name';
        }
        return null;
      },
    );
  }

  Widget _buildBudgetField() {
    return TextFormField(
      controller: _budgetController,
      decoration: const InputDecoration(
        labelText: 'Budget',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null) {
          return 'Invalid number';
        }
        return null;
      },
    );
  }

  Widget _buildCurrencyField() {
    return TextFormField(
      controller: _currencyController,
      decoration: const InputDecoration(
        labelText: 'Currency (USD, EUR, etc.)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      decoration: const InputDecoration(
        labelText: 'Note (Optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  } */
}
