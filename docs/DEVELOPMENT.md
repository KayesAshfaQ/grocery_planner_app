# Development Guide

## Code Organization

### Single-Responsibility Files

| Purpose | File Location | Pattern |
|---------|--------------|---------|
| Theme & Colors | `lib/config/theme/app_theme.dart` | Static utility class |
| Icon Definitions | `lib/config/theme/app_icons.dart` | Static maps by category |
| Routing | `lib/config/routes/app_router.dart` | GoRouter configuration |
| Dependency Injection | `lib/core/di/service_locator.dart` | GetIt setup |
| Service Initialization | `lib/core/services/app_service.dart` | Async init function |
| User Settings | `lib/core/services/user_settings_service.dart` | Singleton service |
| Event Bus | `lib/core/event/app_event_bus.dart` | Broadcast stream |
| Exceptions | `lib/core/error/exceptions.dart` | Custom exception classes |

## Adding New Features

### 1. Domain Layer (Business Logic First)
```bash
lib/features/{feature}/domain/
├── entities/           # Business objects (extend Equatable)
├── repositories/       # Repository interfaces (abstract classes)
└── usecases/          # Business operations (return Either)
```

**Checklist**:
- [ ] Create entities with `copyWith` methods
- [ ] Define repository interface
- [ ] Implement use cases with single responsibility
- [ ] Consolidate related operations in one use case class

### 2. Data Layer (Data Access)
```bash
lib/features/{feature}/data/
├── models/            # DTOs with serialization
├── datasources/       # Local (Floor) or Remote (Dio)
└── repositories/      # Repository implementations
```

**Checklist**:
- [ ] Create models extending entities
- [ ] Add `toJson`/`fromJson` methods
- [ ] Implement data sources
- [ ] Implement repository interface
- [ ] Convert exceptions to Either results

### 3. Presentation Layer (UI)
```bash
lib/features/{feature}/presentation/
├── blocs/             # State management
│   ├── {feature}_event.dart
│   ├── {feature}_state.dart
│   └── {feature}_bloc.dart
├── pages/             # Screen widgets
└── widgets/           # Reusable components
```

**Checklist**:
- [ ] Create events (extend Equatable)
- [ ] Create states (Loading, Loaded, Error)
- [ ] Implement BLoC with event handlers
- [ ] Create page with `.create()` factory
- [ ] Define `static const routePath`
- [ ] Build reusable widgets

### 4. Integration (Wire Everything)

**Checklist**:
- [ ] Register dependencies in `service_locator.dart`
  - Data sources → Repositories → Use cases → BLoCs
  - BLoCs as factories, services as singletons
- [ ] Add routes in `app_router.dart`
- [ ] Add AppEventBus listeners if needed
- [ ] Update dashboard navigation if required

### 5. Database Changes

After modifying models with `@Entity` or `@dao` annotations:

```bash
flutter packages pub run build_runner build
```

## Common Development Tasks

### Adding a New Route
```dart
// 1. In your page widget
class FeaturePage extends StatelessWidget {
  static const routePath = '/feature/:id';
  
  static Widget create({required String id}) {
    return BlocProvider(
      create: (context) => sl<FeatureBloc>()..add(LoadEvent(id)),
      child: const FeaturePage(),
    );
  }
}

// 2. In app_router.dart
GoRoute(
  path: FeaturePage.routePath,
  builder: (context, state) {
    final id = state.pathParameters['id'] ?? '';
    return FeaturePage.create(id: id);
  },
)

// 3. Navigate
context.push('/feature/123');
```

### Adding a New Dependency
```dart
// In service_locator.dart
Future<void> initServiceLocator(AppDatabase database) async {
  // 1. Register data source
  sl.registerLazySingleton<FeatureDataSource>(
    () => FeatureDataSourceImpl(database.featureDao)
  );
  
  // 2. Register repository
  sl.registerLazySingleton<FeatureRepository>(
    () => FeatureRepositoryImpl(sl())
  );
  
  // 3. Register use case
  sl.registerLazySingleton(() => GetFeatureUsecase(sl()));
  
  // 4. Register BLoC as factory
  sl.registerFactory(() => FeatureBloc(getFeatureUsecase: sl()));
}
```

### Cross-BLoC Communication
```dart
// Publisher BLoC
class EditorBloc extends Bloc<EditorEvent, EditorState> {
  final AppEventBus _eventBus;
  
  EditorBloc({required AppEventBus eventBus}) : _eventBus = eventBus;
  
  FutureOr<void> _onSave(SaveEvent event, Emitter<State> emit) async {
    // ... save logic
    _eventBus.fire(ItemSavedEvent(item)); // Notify others
  }
}

// Subscriber BLoC
class ListBloc extends Bloc<ListEvent, ListState> {
  late final StreamSubscription _eventSubscription;
  
  ListBloc({required AppEventBus eventBus}) {
    _eventSubscription = eventBus.stream.listen((event) {
      if (event is ItemSavedEvent) {
        add(RefreshListEvent());
      }
    });
  }
  
  @override
  Future<void> close() {
    _eventSubscription.cancel(); // Critical!
    return super.close();
  }
}
```

### Modifying Theme/Colors
```dart
// In app_theme.dart only
static ThemeData get lightTheme {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green, // Change here
      brightness: Brightness.light,
    ),
    // ... other theme properties
  );
}
```

### Adding Icons
```dart
// In app_icons.dart
class AppIcons {
  static final Map<String, IconData> categoryIcons = {
    'new_category': Icons.new_icon,
    // Add more icons
  };
}

// Usage
Icon(AppIcons.categoryIcons['new_category'])
```

## Widget Refactoring Pattern

When creating similar form widgets (add/edit), use a unified widget instead of duplicating code:

```dart
// ✅ PREFERRED: Single widget with configuration
class ItemFormBottomSheet extends StatefulWidget {
  final ItemFormConfig config;
  
  factory ItemFormBottomSheet.forAdd() => ...
  factory ItemFormBottomSheet.forEdit(Item item) => ...
  
  static Future<void> showAdd(BuildContext context) => ...
  static Future<void> showEdit(BuildContext context, Item item) => ...
}

// Configuration class
class ItemFormConfig {
  final String title;
  final Item? initialItem;
  final bool isEditMode;
  
  factory ItemFormConfig.forAdd() => ...
  factory ItemFormConfig.forEdit(Item item) => ...
}

// ❌ AVOID: Separate widgets with duplicated code
class AddItemBottomSheet { ... }  // 70% similar
class EditItemBottomSheet { ... } // to this one
```

**Benefits**: 40-70% code reduction, single source of truth, easier maintenance.

## Common Mistakes to Avoid

### ❌ Don't Do This

1. **Registering BLoCs as singletons**
   ```dart
   sl.registerLazySingleton(() => SomeBloc(...)); // WRONG
   ```

2. **Adding business logic in widgets**
   ```dart
   // WRONG: Business logic in UI
   if (item.price > 100 && user.isPremium) { ... }
   ```

3. **Forgetting to cancel subscriptions**
   ```dart
   // WRONG: Memory leak
   _eventBus.stream.listen((event) { ... });
   // No cancel in close()
   ```

4. **Creating multiple use case classes for related operations**
   ```dart
   // WRONG
   class AddItemUsecase { ... }
   class AddMultipleItemsUsecase { ... } // Should be one class
   ```

5. **Emitting loading states for CRUD operations**
   ```dart
   // WRONG: Causes UI flickers
   emit(LoadingState());
   final result = await updateItem();
   ```

### ✅ Do This Instead

1. **Register BLoCs as factories**
   ```dart
   sl.registerFactory(() => SomeBloc(...)); // CORRECT
   ```

2. **Put business logic in use cases**
   ```dart
   // CORRECT: Business logic in domain layer
   class ValidatePurchaseUsecase { ... }
   ```

3. **Always cancel subscriptions**
   ```dart
   // CORRECT
   @override
   Future<void> close() {
     _eventSubscription.cancel();
     return super.close();
   }
   ```

4. **Consolidate related use cases**
   ```dart
   // CORRECT
   class ManageItemsUsecase {
     Future<Either<...>> call(Item item) { ... }
     Future<Either<...>> addMultiple(List<Item> items) { ... }
   }
   ```

5. **Update state directly**
   ```dart
   // CORRECT: Efficient update
   if (state is LoadedState) {
     final updated = [...currentState.items, newItem];
     emit(LoadedState(items: updated));
   }
   ```

## Build Commands

```bash
# Code generation (after model changes)
flutter packages pub run build_runner build

# Clean build
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run specific test
flutter test test/features/purchase_list/domain/usecases/add_purchase_item_test.dart

# Build APK
flutter build apk

# Build for iOS
flutter build ios

# Run with specific device
flutter run -d chrome
flutter run -d <device-id>
```

## Testing

### Unit Tests (Use Cases)
```dart
test('should add purchase item successfully', () async {
  // Arrange
  when(mockRepository.addItem(any)).thenAnswer((_) async => Right(item));
  
  // Act
  final result = await usecase(item);
  
  // Assert
  expect(result, Right(item));
  verify(mockRepository.addItem(item));
});
```

### BLoC Tests
```dart
blocTest<FeatureBloc, FeatureState>(
  'emits [Loading, Loaded] when event succeeds',
  build: () => FeatureBloc(usecase: mockUsecase),
  act: (bloc) => bloc.add(LoadEvent()),
  expect: () => [LoadingState(), LoadedState(data: testData)],
);
```

## Quick Reference

| Task | Command/Location |
|------|-----------------|
| Generate feature | `./scripts/create_feature.sh` |
| Run build_runner | `flutter packages pub run build_runner build` |
| Add dependency | Edit `pubspec.yaml` then `flutter pub get` |
| Register dependency | Edit `lib/core/di/service_locator.dart` |
| Add route | Edit `lib/config/routes/app_router.dart` |
| Change theme | Edit `lib/config/theme/app_theme.dart` |
| Add exception | Edit `lib/core/error/exceptions.dart` |
| Run tests | `flutter test` |
