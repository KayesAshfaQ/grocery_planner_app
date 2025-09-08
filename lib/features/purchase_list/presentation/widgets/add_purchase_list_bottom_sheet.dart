import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/core/services/user_settings_service.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/toast/app_toast.dart';

class AddPurchaseListBottomSheet extends StatefulWidget {
  const AddPurchaseListBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPurchaseListBottomSheet> createState() =>
      _AddPurchaseListBottomSheetState();

  /// Show this bottom sheet
  static Future<void> show(BuildContext context, {int? listId}) {
    return AppBottomSheet.show(
      context: context,
      child: BlocProvider.value(
        value: context.read<PurchaseListBloc>(),
        child: AddPurchaseListBottomSheet(),
      ),
    );
  }
}

class _AddPurchaseListBottomSheetState
    extends State<AddPurchaseListBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Get settings service for accessing user preferences
  final UserSettingsService _settingsService = sl<UserSettingsService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _handleAddItem() {
    final name = _nameController.text.trim();
    final budget = double.tryParse(_budgetController.text);
    final note = _noteController.text.trim();

    if (name.isEmpty) {
      AppToast.showWarning(context, 'Please enter an item name');
      return;
    }

    final newList = PurchaseList(
      name: name,
      budget: budget,
      currencySymbol: _settingsService.defaultCurrency,
      note: note,
    );

    context.read<PurchaseListBloc>().add(AddPurchaseListEvent(item: newList));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseListBloc, PurchaseListState>(
      builder: (context, state) {
        if (state is PurchaseListLoadedState) {
          return AppBottomSheet(
            title: 'Add New Purchase List',
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: 'Total Budget',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleAddItem,
                  child: const Text('ADD ITEM'),
                ),
              ],
            ),
          );
        }

        return const AppBottomSheet(
          title: 'Add New Item',
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
