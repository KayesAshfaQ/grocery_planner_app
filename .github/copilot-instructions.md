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

### 2. Cross-BLoC Communication via AppEventBus

**Critical Pattern**: Use `AppEventBus` (singleton) for reactive communication between BLoCs without direct dependencies.

**Event Publishing** (in BLoC event handlers):
```dart
class PurchaseListEditorBloc extends Bloc<Event, State> {
  final AppEventBus _eventBus;
  
  FutureOr<void> _onAddItem(AddItemEvent event, Emitter<State> emit) async {
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

### 3. BLoC Usage Patterns

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

### 4. Shared Widgets Pattern

Reusable widgets live in `lib/features/shared/presentation/widgets/`. Key examples:

- `AppBottomSheet`: Standardized bottom sheet with keyboard handling and form support
- `AppToast`: Consistent toast messages (`AppToast.showSuccess(context, message)`)

## Development Workflows

### Database Operations
- Uses **Floor** (SQLite ORM) with code generation
- Run `flutter packages pub run build_runner build` after model changes
- DAO pattern for database access (`lib/core/db/dao/`)

### Dependency Injection
- Uses **GetIt** service locator pattern
- Register dependencies in `lib/core/di/service_locator.dart`
- Access via `sl<Type>()` throughout the app

### State Management Conventions
- **BLoC pattern** for all state management
- Events implement `Equatable` for proper comparison
- States include Loading, Success, Error variants
- Use `AppEventBus` for cross-BLoC communication (see pattern above)

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

### Error Handling
- Use `dartz` Either<Failure, Success> pattern in use cases
- Standardized error states in BLoCs
- Toast notifications for user feedback

## Critical Implementation Details

1. **AppEventBus Memory Management**: Always cancel event subscriptions in BLoC `close()` methods
2. **Bottom Sheet Responsiveness**: Use `ConstrainedBox` instead of `Expanded` to prevent keyboard overflow
3. **Database Models**: Include proper `@Entity` annotations and converters for complex types
4. **Service Locator**: Register BLoCs as factories, services as singletons in `service_locator.dart`

## Testing Approach
- Use `bloc_test` for BLoC unit tests
- Mock dependencies with `mockito`
- Test event-driven communication via `AppEventBus` in integration tests

When implementing new features, follow the established patterns above and use the feature generation script for consistency.
