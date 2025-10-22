# Grocery Planner App - AI Agent Instructions

## Architecture Overview

This Flutter app follows **Clean Architecture** with feature-driven development. The codebase is organized into three main layers:

- **Domain Layer**: Entities, repositories (interfaces), and use cases
- **Data Layer**: Models, data sources, and repository implementations  
- **Presentation Layer**: BLoCs, pages, and widgets

## Key Architectural Patterns

### 1. Feature-Based Structure
```
lib/features/{feature_name}/
├── domain/       # Business logic, entities, use cases
├── data/         # Data sources, models, repositories
└── presentation/ # BLoCs, pages, widgets
```

Use the `scripts/create_feature.sh` script to generate new features with proper Clean Architecture structure.

### 2. Shared Components Pattern

Shared entities, models, and widgets live in `lib/features/shared/`:
- `lib/features/shared/domain/entities/` - Core business entities
- `lib/features/shared/data/models/` - Shared database models 
- `lib/features/shared/presentation/widgets/` - Reusable UI components

### 3. Cross-BLoC Communication via AppEventBus

**Critical Pattern**: Use `AppEventBus` (singleton) for reactive communication between BLoCs without direct dependencies.

**Event Publishing** (in BLoC event handlers):
```dart
class PurchaseListEditorBloc extends Bloc<Event, State> {
  final AppEventBus _eventBus;
  
  FutureOr<void> _onAddPurchaseList(AddPurchaseListEvent event, Emitter<State> emit) async {
    // ... business logic
    _eventBus.fire(event); // Notify other BLoCs
    emit(SuccessState());
  }
}
```

**Event Consumption** (in BLoC constructor):
```dart
class PurchaseListBloc extends Bloc<Event, State> {
  late final StreamSubscription _eventSubscription;
  
  PurchaseListBloc({required AppEventBus eventBus}) : super(InitialState()) {
    _eventSubscription = eventBus.stream.listen((event) {
      if (event is AddPurchaseListEvent) {
        add(GetAllPurchaseItemsEvent()); // Refresh data
      }
    });
  }
  
  @override
  Future<void> close() {
    _eventSubscription.cancel(); // ALWAYS cancel subscriptions
    return super.close();
  }
}
```

### 4. BLoC Usage Patterns

**Creation Pattern** (use `sl<Bloc>()..add()` for new instances):
```dart
static Widget create({required String id}) {
  return BlocProvider(
    create: (context) => sl<PurchaseListEditorBloc>()..add(LoadInitialDataEvent(id: id)),
    child: const PurchaseListEditorPage(),
  );
}
```

**Interaction Pattern** (use `context.read<Bloc>().add()` for existing instances):
```dart
onPressed: () => context.read<PurchaseListEditorBloc>().add(RemoveItemEvent(id: item.id))
```

### 5. Shared Widgets Pattern

Reusable widgets live in `lib/features/shared/presentation/widgets/`. Key examples:

- `AppBottomSheet`: Standardized bottom sheet with keyboard handling and form support
- `AppToast`: Consistent toast messages (`AppToast.showSuccess(context, message)`)

### 6. Routing with GoRouter

Uses **StatefulShellRoute.indexedStack** for bottom navigation with nested routes:

```dart
// Navigate to editor with ID parameter
context.push('/purchase-lists/editor/123');

// Access route parameters  
final id = int.parse(state.pathParameters['purchaseListId'] ?? '');
return PurchaseListEditorPage.create(id: id);
```

**Route Structure**:
- `/purchase-lists` - Main list with nested `/editor/:id` for editing
- `/catalog` - Catalog management
- `/categories` - Category management  
- `/schedule` - Shopping schedule
- `/settings` - App settings

## Development Workflows

### Database Operations
- Uses **Floor** (SQLite ORM) with code generation
- Run `flutter packages pub run build_runner build` after model changes
- DAO pattern for database access (`lib/core/db/dao/`)
- Type converters in `lib/core/db/converter/` for complex types (DateTime, etc.)

### Dependency Injection
- Uses **GetIt** service locator pattern
- Register dependencies in `lib/core/di/service_locator.dart`
- Access via `sl<Type>()` throughout the app
- **Pattern**: BLoCs as factories, services as singletons

### Use Case Design Patterns
- **Use Cases represent application-specific business rules** and orchestrate data flow
- **Single Responsibility**: Each use case should have one clear business purpose
- **Consolidation Rule**: If multiple operations serve the **same business case**, consolidate them into a single use case with multiple methods instead of creating separate use case classes

#### **Use Case Consolidation Pattern**:
```dart
// ✅ PREFERRED: Single use case with related methods
class AddPurchaseItemUsecase {
  final PurchaseRepository repository;
  
  AddPurchaseItemUsecase(this.repository);
  
  /// Adds a single purchase item
  Future<Either<AppException, PurchaseItem>> call(PurchaseItem item) async {
    return repository.addPurchaseItem(item);
  }
  
  /// Adds multiple purchase items in a single transaction
  Future<Either<AppException, List<PurchaseItem>>> addMultiple(List<PurchaseItem> items) async {
    return repository.addMultiplePurchaseItems(items);
  }
}
```

```dart
// ❌ AVOID: Separate use cases for the same business purpose
class AddPurchaseItemUsecase { ... }           // Single item
class AddMultiplePurchaseItemsUsecase { ... }  // Bulk items - UNNECESSARY
```

**When to consolidate:**
- Operations serve the **same core business purpose** (e.g., "adding items to list")
- Different variants of the same operation (single vs bulk, different parameters)
- Related CRUD operations that work on the same entity type

**When to separate:**
- **Fundamentally different business operations** with different purposes
- Different transaction scopes or error handling requirements
- Operations that will evolve independently with different dependencies

**Usage pattern:**
```dart
// Single item
final result = await addPurchaseItemUsecase(item);

// Bulk operation
final result = await addPurchaseItemUsecase.addMultiple(items);
```

### Build & Test Commands
```bash
# Database code generation (after model changes)
flutter packages pub run build_runner build

# Run tests  
flutter test

# Build APK
flutter build apk

# Build for iOS
flutter build ios

# Generate new feature structure
./scripts/create_feature.sh
```

### State Management Conventions
- **BLoC pattern** for all state management
- Events implement `Equatable` for proper comparison
- States include Loading, Success, Error variants
- Use `AppEventBus` for cross-BLoC communication (see pattern above)
- **🚨 CRITICAL: Avoid unnecessary loading states in CRUD operations** - use efficient state updates to prevent UI flickers and screen snapping

#### **Efficient State Updates Pattern** (Preferred over dedicated states):

When performing operations like Add/Update/Delete, prefer updating the existing loaded state instead of creating dedicated operation states:

```dart
FutureOr<void> _onAddItem(AddItemEvent event, Emitter<State> emit) async {
  // ❌ AVOID: Unnecessary loading state causes UI flickers
  // emit(LoadingState());
  
  final result = await usecase(event.item);
  
  result.fold(
    (failure) => emit(ErrorState(message: failure.toString())),
    (newItem) {
      // ✅ PREFERRED: Update existing loaded state directly
      if (state is LoadedState) {
        final currentState = state as LoadedState;
        final updatedItems = [...currentState.items, newItem];
        emit(LoadedState(items: updatedItems));
      } else {
        // Fallback: Trigger full reload
        add(GetAllItemsEvent());
      }
    },
  );
}
```

**Benefits:**
- ✅ No need for dedicated `ItemAddedState`, `ItemUpdatedState`, etc.
- ✅ UI stays responsive with immediate state updates
- ✅ Simpler state management with fewer state classes
- ✅ Consistent user experience without loading flickers
- ✅ Efficient memory usage by reusing existing state structure
- ✅ **Avoids unnecessary loading states that cause screen snapping/refreshing**

**Critical Rule:** For CRUD operations on existing loaded data, avoid `emit(LoadingState())` as it causes jarring UI transitions and poor user experience.

**Use this pattern for:** Add, Update, Delete operations that modify existing collections

**Example from PurchaseListBloc:** The `_onAddPurchaseList` method efficiently updates the loaded state by adding the new item to the existing list instead of creating a separate `PurchaseListAddedState`.

**When to use dedicated states:** Complex operations that require different UI handling or when the state structure doesn't easily support inline updates.

## UI/UX Patterns

### Bottom Sheet Best Practices
```dart
// Keyboard-aware responsive bottom sheet
AppBottomSheet(
  content: Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3),
        child: Column(children: [...]),
      ),
    ),
  ),
)
```

### Shared Widget Usage
```dart
// Form-based bottom sheet with validation
AppBottomSheet.form(
  title: 'Add Item',
  formKey: _formKey,
  formFields: [_buildNameField(), _buildPriceField()],
  onSubmit: () => _handleSubmit(),
);

// Interactive bottom sheet with custom controls (like QuantityUpdateBottomSheet)
AppBottomSheet.show(
  context: context,
  child: CustomBottomSheet(
    onUpdate: (data) => context.read<SomeBloc>().add(UpdateEvent(data)),
  ),
);

// Consistent toast notifications
AppToast.showSuccess(context, 'Item added successfully');
AppToast.showError(context, 'Failed to save item');
```

### Interactive List Items Pattern
```dart
// Tappable list items for inline editing
ListTile(
  title: Text(item.name),
  subtitle: Text('${item.quantity} pcs'),
  trailing: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () => _handleDelete(item),
  ),
  onTap: () => _showEditBottomSheet(context, item), // Tap to edit
)
```

### Widget Refactoring Patterns

#### **DRY Principle for Form Widgets** 🚨 CRITICAL
When creating similar form widgets (add/edit operations), avoid code duplication by following these patterns:

**❌ AVOID: Separate widgets for similar operations**
```dart
// Duplicated code with 70%+ similarity
class AddItemBottomSheet extends StatefulWidget { ... }
class EditItemBottomSheet extends StatefulWidget { ... }
```

**✅ PREFERRED: Unified widget with configuration-driven behavior**
```dart
// Single widget with mode-specific configuration
class ItemFormBottomSheet extends StatefulWidget {
  final ItemFormConfig config;
  
  factory ItemFormBottomSheet.forAdd() => ...
  factory ItemFormBottomSheet.forEdit(Item item) => ...
  
  static Future<void> showAdd(BuildContext context) => ...
  static Future<void> showEdit(BuildContext context, Item item) => ...
}

class ItemFormConfig {
  final String title;
  final Item? initialItem;
  final bool isEditMode;
  final String successMessage;
  
  factory ItemFormConfig.forAdd() => ...
  factory ItemFormConfig.forEdit(Item item) => ...
}
```

**Implementation Rules:**
1. **Extract Common Utilities**: Create helper classes for shared logic (e.g., `IconUtils`, `ValidationUtils`)
2. **Configuration Pattern**: Use configuration objects to drive different behaviors
3. **Factory Constructors**: Provide clean APIs with `.forAdd()` and `.forEdit()` methods
4. **Strategy Pattern**: Different submit strategies for different operations
5. **Single Responsibility**: One widget handles the form, configuration handles the behavior

**Benefits:**
- ✅ **Reduces codebase by 40-70%** depending on similarity
- ✅ **Single source of truth** for form logic and validation
- ✅ **Easier maintenance** - one file to update instead of multiple
- ✅ **Consistent UX** across add/edit operations
- ✅ **Better testability** with unified logic
- ✅ **Future-ready** for new modes (duplicate, template, etc.)

**Example Implementation Structure:**
```dart
lib/features/{feature}/presentation/
├── utils/
│   └── {feature}_form_utils.dart     # Shared utilities
├── widgets/
│   └── {feature}_form_bottom_sheet.dart  # Unified form widget
└── pages/
    └── {feature}_page.dart           # Updated to use unified widget
```

**Real Implementation Example (Category Feature):**
```dart
// ✅ CategoryFormBottomSheet - Unified widget
class CategoryFormBottomSheet extends StatefulWidget {
  factory CategoryFormBottomSheet.forAdd() => ...
  factory CategoryFormBottomSheet.forEdit(Category category) => ...
  
  static Future<void> showAdd(BuildContext context) => ...
  static Future<void> showEdit(BuildContext context, Category category) => ...
}

// ✅ CategoryIconUtils - Shared utilities
class CategoryIconUtils {
  static IconData? parseIconFromUri(String? imageUri) => ...
  static String? iconToUri(IconData? icon) => ...
}

// ✅ Usage in CategoryPage
CategoryFormBottomSheet.showAdd(context);           // Add mode
CategoryFormBottomSheet.showEdit(context, category); // Edit mode
```

**When to Refactor:**
- When two or more widgets share >50% similar code
- Form widgets with identical field structures
- Add/edit operations with same validation logic
- Similar UI patterns across different modes

### Error Handling
- Use `dartz` Either<Failure, Success> pattern in use cases
- Standardized error states in BLoCs
- Toast notifications for user feedback
- Custom exceptions in `lib/core/error/exceptions.dart`

## Critical Implementation Details

1. **AppEventBus Memory Management**: Always cancel event subscriptions in BLoC `close()` methods
2. **Bottom Sheet Responsiveness**: Use `ConstrainedBox` instead of `Expanded` to prevent keyboard overflow
3. **Database Models**: Include proper `@Entity` annotations and converters for complex types
4. **Service Locator**: Register BLoCs as factories, services as singletons in `service_locator.dart`
5. **Route Parameters**: Parse IDs as integers for type safety (`int.tryParse(state.pathParameters['id'])`)
6. **Entity Updates**: Use `copyWith` methods for immutable entity updates instead of creating new instances
7. **Use Case Consolidation**: For related business operations (single vs bulk, variations of same purpose), use one use case class with multiple methods instead of creating separate use case classes
8. **Widget Refactoring**: When creating similar form widgets (add/edit operations), use unified widgets with configuration-driven behavior to eliminate code duplication. Follow the Widget Refactoring Patterns above.

## Testing Approach
- Use `bloc_test` for BLoC unit tests
- Mock dependencies with `mockito`
- Test event-driven communication via `AppEventBus` in integration tests

When implementing new features, follow the established patterns above and use the feature generation script for consistency.
