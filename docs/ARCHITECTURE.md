# Architecture Documentation

## Overview

This application follows **Clean Architecture** principles, separating the codebase into three distinct layers with clear responsibilities and boundaries.

## Clean Architecture Layers

### 1. Domain Layer (Business Logic)
- **Entities**: Pure Dart classes representing business objects
- **Repositories**: Interfaces defining data operations contracts
- **Use Cases**: Application-specific business rules

### 2. Data Layer (Data Access)
- **Data Sources**: Local (Floor/SQLite) and Remote (API) implementations
- **Models**: Data transfer objects with serialization
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. Presentation Layer (UI)
- **BLoCs**: State management using flutter_bloc
- **Pages**: Screen widgets with routing
- **Widgets**: Reusable UI components

## Directory Structure

```
lib/
├── config/                  # App configuration
│   ├── routes/              # Navigation setup (GoRouter)
│   └── theme/               # Theme and icon definitions
├── core/                    # Core infrastructure
│   ├── di/                  # Dependency injection (GetIt)
│   ├── db/                  # Database setup (Floor)
│   ├── error/               # Exception definitions
│   ├── event/               # Event bus for cross-BLoC communication
│   └── services/            # App-wide services
├── features/                # Feature modules
│   ├── {feature}/           # Each feature has:
│   │   ├── domain/          # Entities, repositories, use cases
│   │   ├── data/            # Models, data sources, repo implementations
│   │   └── presentation/    # BLoCs, pages, widgets
│   └── shared/              # Shared entities, models, widgets
```

## Key Architectural Patterns

### Event-Driven Communication (AppEventBus)

**Purpose**: Enable reactive communication between BLoCs without direct dependencies.

**Implementation**:
```dart
// 1. Event Definition
class ItemAddedEvent extends SomeEvent implements AppEvent {
  final Item item;
  const ItemAddedEvent(this.item);
}

// 2. Publishing Events (in Editor BLoC)
_eventBus.fire(ItemAddedEvent(item));

// 3. Consuming Events (in List BLoC)
_eventSubscription = _eventBus.stream.listen((event) {
  if (event is ItemAddedEvent) {
    add(RefreshListEvent());
  }
});

// 4. Cleanup
@override
Future<void> close() {
  _eventSubscription.cancel();
  return super.close();
}
```

**Benefits**:
- Loose coupling between features
- Scalable event-driven architecture
- Easy to test with mock event bus
- Clear separation of concerns

### BLoC Usage Patterns

#### Creating New BLoC Instances
Use `sl<Bloc>()..add()` when creating pages:

```dart
static Widget create({required String id}) {
  return BlocProvider(
    create: (context) => sl<EditorBloc>()..add(LoadEvent(id)),
    child: const EditorPage(),
  );
}
```

#### Interacting with Existing BLoCs
Use `context.read<Bloc>().add()` for user interactions:

```dart
onPressed: () => context.read<EditorBloc>().add(SaveEvent())
```

### Use Case Consolidation Pattern

**Rule**: Consolidate related operations in a single use case class instead of creating multiple classes.

```dart
// ✅ PREFERRED: Related operations in one class
class ManageItemsUsecase {
  Future<Either<AppException, Item>> call(Item item) { ... }
  Future<Either<AppException, List<Item>>> addMultiple(List<Item> items) { ... }
}

// ❌ AVOID: Separate classes for same business purpose
class AddItemUsecase { ... }
class AddMultipleItemsUsecase { ... }
```

### Efficient State Updates

**Rule**: For CRUD operations, update existing loaded state instead of emitting loading states.

```dart
FutureOr<void> _onAddItem(AddItemEvent event, Emitter<State> emit) async {
  // ❌ AVOID: Causes UI flickers
  // emit(LoadingState());
  
  final result = await usecase(event.item);
  
  result.fold(
    (failure) => emit(ErrorState(message: failure.toString())),
    (newItem) {
      // ✅ PREFERRED: Update existing state directly
      if (state is LoadedState) {
        final currentState = state as LoadedState;
        final updatedItems = [...currentState.items, newItem];
        emit(LoadedState(items: updatedItems));
      }
    },
  );
}
```

**Benefits**:
- No UI flickers or screen refreshing
- Simpler state management
- Better user experience
- Fewer state classes needed

## Dependency Injection

Using **GetIt** service locator pattern:

### Registration Order
1. Core services (EventBus, NetworkInfo)
2. External dependencies (SharedPreferences, Connectivity)
3. Data sources (local/remote)
4. Repositories
5. Use cases
6. Services
7. BLoCs (always as factories)

### Registration Patterns
```dart
// Singletons (shared instance)
sl.registerLazySingleton(() => AppEventBus());

// Factories (new instance each time)
sl.registerFactory(() => SomeBloc(...));

// Instances (already created)
sl.registerSingleton<Database>(database);
```

**Critical Rule**: BLoCs must ALWAYS be registered as factories, never singletons.

## Routing

Using **GoRouter** with `StatefulShellRoute.indexedStack` for bottom navigation.

### Route Structure
```dart
GoRoute(
  path: '/feature/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    return FeaturePage.create(id: id);
  },
)
```

**Pattern**: Every page defines `static const routePath` and a factory `.create()` method.

## Database

Using **Floor** (SQLite ORM) with code generation.

### After Model Changes
```bash
flutter packages pub run build_runner build
```

### Patterns
- DAO pattern for database access
- Type converters for complex types (DateTime, enums)
- Entities with proper `@Entity` annotations

## Error Handling

Using **dartz** Either pattern:

```dart
// In Use Cases
Future<Either<AppException, Result>> call() async {
  try {
    final result = await repository.getData();
    return Right(result);
  } catch (e) {
    return Left(ServerException(message: e.toString()));
  }
}

// In BLoCs
result.fold(
  (failure) => emit(ErrorState(message: failure.toString())),
  (data) => emit(LoadedState(data: data)),
);
```

## Testing Strategy

- **Unit Tests**: Use cases and repositories
- **BLoC Tests**: Using `bloc_test` package
- **Widget Tests**: UI components
- **Integration Tests**: Event bus communication
- **Mocking**: Using `mockito` for dependencies

## Best Practices

1. **Single Responsibility**: Each class has one clear purpose
2. **Dependency Inversion**: Depend on abstractions, not implementations
3. **Immutability**: Use `const` and `final` where possible
4. **Type Safety**: Leverage Dart's type system
5. **Clean Code**: Follow Dart style guide
6. **Documentation**: Document public APIs and complex logic
7. **Memory Management**: Always dispose streams and subscriptions
