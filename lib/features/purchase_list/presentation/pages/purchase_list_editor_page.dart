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
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/quantity_update_bottom_sheet.dart';

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

          // budget of the list
          Text(
            purchaseList?.budget != null
                ? 'Budget: ${purchaseList!.budget} ${purchaseList.currencySymbol ?? 'USD'}'
                : 'No budget set',
            style: Theme.of(context).textTheme.bodyMedium,
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

          // -------------- Purchase Item Section --------------
          const SizedBox(height: 16),
          Text(
            'Add New Item',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: (purchaseList?.purchaseItems.isNotEmpty == true)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: purchaseList?.purchaseItems.length,
                      itemBuilder: (context, index) {
                        /// Get the purchase item at the current index
                        final item = purchaseList?.purchaseItems[index];

                        return ListTile(
                          title: Text(item?.customName ??
                              'Item #${item?.catalogId ?? 'N/A'}'),
                          subtitle: Text(
                            '${item?.quantity} pc - ${item?.unitPrice != null ? '\$${item?.unitPrice}' : 'No price set'}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () {
                              context.read<PurchaseListEditorBloc>().add(
                                    RemoveItemFromPurchaseListEvent(
                                        id: item!.id!),
                                  );
                            },
                          ),
                          onTap: () {
                            if (item != null) {
                              _showQuantityUpdateBottomSheet(context, item);
                            }
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.0),
                        child: Text(
                          'No items added yet.\nTap \'➕ button\' to add items.',
                          textAlign: TextAlign.center,
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
