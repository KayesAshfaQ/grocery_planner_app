import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/core/services/user_settings_service.dart';
import 'package:grocery_planner_app/features/purchase_list/presentation/blocs/purchase_list/purchase_list_bloc.dart';
import 'package:grocery_planner_app/features/shared/domain/entities/purchase_list.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/bottom_sheets/app_bottom_sheet.dart';
import 'package:grocery_planner_app/features/shared/presentation/widgets/toast/app_toast.dart';

/// Configuration class for purchase list form behavior
class PurchaseListFormConfig {
  final String title;
  final PurchaseList? initialPurchaseList;
  final bool isEditMode;
  final String successMessage;

  const PurchaseListFormConfig._({
    required this.title,
    required this.isEditMode,
    required this.successMessage,
    this.initialPurchaseList,
  });

  /// Factory constructor for add mode
  factory PurchaseListFormConfig.forAdd() {
    return const PurchaseListFormConfig._(
      title: 'Add New Purchase List',
      isEditMode: false,
      successMessage: 'Purchase list added successfully',
    );
  }

  /// Factory constructor for edit mode
  factory PurchaseListFormConfig.forEdit(PurchaseList purchaseList) {
    return PurchaseListFormConfig._(
      title: 'Edit Purchase List',
      isEditMode: true,
      successMessage: 'Purchase list updated successfully',
      initialPurchaseList: purchaseList,
    );
  }
}

/// Unified purchase list form widget supporting both add and edit modes
class PurchaseListFormBottomSheet extends StatefulWidget {
  final PurchaseListFormConfig config;

  const PurchaseListFormBottomSheet._({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<PurchaseListFormBottomSheet> createState() =>
      _PurchaseListFormBottomSheetState();

  /// Factory constructor for add mode
  factory PurchaseListFormBottomSheet.forAdd() {
    return PurchaseListFormBottomSheet._(
      config: PurchaseListFormConfig.forAdd(),
    );
  }

  /// Factory constructor for edit mode
  factory PurchaseListFormBottomSheet.forEdit(PurchaseList purchaseList) {
    return PurchaseListFormBottomSheet._(
      config: PurchaseListFormConfig.forEdit(purchaseList),
    );
  }

  /// Show add purchase list bottom sheet
  static Future<void> showAdd(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      child: BlocProvider.value(
        value: context.read<PurchaseListBloc>(),
        child: PurchaseListFormBottomSheet.forAdd(),
      ),
    );
  }

  /// Show edit purchase list bottom sheet
  static Future<void> showEdit(
      BuildContext context, PurchaseList purchaseList) {
    return AppBottomSheet.show(
      context: context,
      child: BlocProvider.value(
        value: context.read<PurchaseListBloc>(),
        child: PurchaseListFormBottomSheet.forEdit(purchaseList),
      ),
    );
  }
}

class _PurchaseListFormBottomSheetState
    extends State<PurchaseListFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late final TextEditingController _noteController;

  // Get settings service for accessing user preferences
  final UserSettingsService _settingsService = sl<UserSettingsService>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Initialize text controllers with initial values for edit mode
  void _initializeControllers() {
    final purchaseList = widget.config.initialPurchaseList;
    _nameController = TextEditingController(text: purchaseList?.name ?? '');
    _budgetController = TextEditingController(
      text: purchaseList?.budget?.toString() ?? '',
    );
    _noteController = TextEditingController(text: purchaseList?.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Handle form submission for both add and edit modes
  void _handleSubmit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final name = _nameController.text.trim();
    final budget = double.tryParse(_budgetController.text);
    final note = _noteController.text.trim();

    if (name.isEmpty) {
      AppToast.showWarning(context, 'Please enter a list name');
      return;
    }

    final purchaseList = PurchaseList(
      id: widget.config.isEditMode
          ? widget.config.initialPurchaseList?.id
          : null,
      name: name,
      budget: budget,
      currencySymbol: _settingsService.defaultCurrency,
      note: note.isEmpty ? null : note,
      createdAt: widget.config.isEditMode
          ? widget.config.initialPurchaseList?.createdAt
          : DateTime.now(),
      isCompleted: widget.config.initialPurchaseList?.isCompleted ?? false,
    );

    // Emit appropriate BLoC event based on mode
    if (widget.config.isEditMode) {
      context
          .read<PurchaseListBloc>()
          .add(UpdatePurchaseListEvent(item: purchaseList));
    } else {
      context
          .read<PurchaseListBloc>()
          .add(AddPurchaseListEvent(item: purchaseList));
    }

    context.pop();

    // Show success message
    AppToast.showSuccess(context, widget.config.successMessage);
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.form(
      title: widget.config.title,
      formKey: _formKey,
      onSubmit: _handleSubmit,
      formFields: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'List Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a list name';
            }
            return null;
          },
          autofocus: true,
        ),
        TextFormField(
          controller: _budgetController,
          decoration: const InputDecoration(
            labelText: 'Budget (Optional)',
            border: OutlineInputBorder(),
            hintText: 'Enter budget amount',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
        ),
        TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: 'Note (Optional)',
            border: OutlineInputBorder(),
            hintText: 'Enter a note...',
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
