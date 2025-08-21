import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/catalog_item.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/category.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/toast/app_toast.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list_editor/purchase_list_editor_bloc.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/widgets/add_item_bottom_sheet.dart';

/// Page for adding a new grocery item
class PurchaseListEditorPage extends StatefulWidget {
  /// Creates a new add grocery item page
  const PurchaseListEditorPage({Key? key}) : super(key: key);

  /// Route path for this page (relative to parent)
  static const String routePath = 'editor';

  /// Factory method that creates the page wrapped with necessary BlocProviders
  static Widget create(/* BuildContext context, */ {required String id}) {
    return BlocProvider(
      create: (context) => sl<PurchaseListEditorBloc>()..add(LoadInitialDataEvent(id: id)),
      child: const PurchaseListEditorPage(),
    );
  }

  @override
  State<PurchaseListEditorPage> createState() => _PurchaseListEditorPageState();
}

class _PurchaseListEditorPageState extends State<PurchaseListEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _currencyController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _currencyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showAddItemBottomSheet(BuildContext context, PurchaseListEditorLoadedState state) {
    // First save the purchase list if it doesn't exist yet
    if (state.purchaseList == null) {
      _submitForm(context, state);
    }

    AddItemBottomSheet.show(
      context,
      listId: state.purchaseList?.id,
    );
  }

  void _submitForm(BuildContext context, PurchaseListEditorLoadedState state) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final name = _nameController.text;
    final budget = double.tryParse(_budgetController.text) ?? 0.0;
    final currency = _currencyController.text;
    final note = _noteController.text;

    /* context.read<PurchaseListEditorBloc>().add(
          AddPurchaseListEvent(
            list: PurchaseList(
              name: name,
              budget: budget,
              currencySymbol: currency,
              note: note,
            ),
          ),
        ); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shopping List'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PurchaseListEditorBloc, PurchaseListEditorState>(
        listener: (context, state) {
          /* if (state is PurchaseListAddedState) {
            AppToast.showSuccess(
              context,
              'Shopping list "${state.list.name}" created successfully!',
            );
          } else */
          if (state is PurchaseItemAddedState) {
            AppToast.showSuccess(
              context,
              'Item "${state.item.customName ?? state.item.catalogItem?.name}" added successfully!',
            );
          } else if (state is PurchaseListEditorErrorState) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is PurchaseListEditorLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle both loaded state and success states to prevent fallback
          if (state is PurchaseListEditorLoadedState || state is PurchaseItemAddedState) {
            // Extract data based on state type
            List<Category> categories = [];
            List<CatalogItem> catalogItems = [];
            PurchaseList? purchaseList;

            if (state is PurchaseListEditorLoadedState) {
              categories = state.categories;
              catalogItems = state.catalogItems;
              purchaseList = state.purchaseList;
            } /* else if (state is PurchaseListAddedState) {
              // For newly added list, we might not have catalog data loaded yet
              // but we have the list
              purchaseList = state.list;
              // Need to reload catalog items and categories
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.read<PurchaseListEditorBloc>().add(LoadCategoriesAndCatalogItemsEvent());
                }
              });
            } */
            else if (state is PurchaseItemAddedState) {
              // For newly added item, reload the full state to get updated list
              /*  WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.read<PurchaseListEditorBloc>().add(LoadCategoriesAndCatalogItemsEvent());
                }
              }); */
              // For now, show loading
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNameField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildBudgetField(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildCurrencyField(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildNoteField(),
                    const SizedBox(height: 16),

                    /// -------------- Add Purchase Item Section --------------
                    Row(
                      children: [
                        Text(
                          'Add New Item',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                          onPressed: () => _showAddItemBottomSheet(
                            context,
                            PurchaseListEditorLoadedState(
                              categories: categories,
                              catalogItems: catalogItems,
                              purchaseList: purchaseList,
                            ),
                          ),
                        ),
                      ],
                    ),
                    (purchaseList?.purchaseItems.isNotEmpty == true)
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: purchaseList?.purchaseItems.length,
                            itemBuilder: (context, index) {
                              /// Get the purchase item at the current index
                              final item = purchaseList?.purchaseItems[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(item?.customName ??
                                      item?.catalogItem?.name ??
                                      'Unknown Item'),
                                  subtitle: Text(
                                    '${item?.quantity} pc - ${item?.unitPrice != null ? '\$${item?.unitPrice}' : 'No price set'}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      context.read<PurchaseListEditorBloc>().add(
                                            RemoveItemFromPurchaseListEvent(id: item!.id!),
                                          );
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('No items added yet. Tap + to add items.'),
                          ),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _submitForm(
                        context,
                        PurchaseListEditorLoadedState(
                          categories: categories,
                          catalogItems: catalogItems,
                          purchaseList: purchaseList,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is PurchaseListEditorLoadingState
                          ? const CircularProgressIndicator()
                          : const Text('ADD SHOPPING LIST'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Fallback for initial state or error state
          return const Center(
            child: Text('Failed to load editor. Please try again.'),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
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
  }
}
