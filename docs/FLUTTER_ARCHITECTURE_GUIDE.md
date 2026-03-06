# Flutter Clean Architecture Guide

A reusable, opinionated architecture blueprint for production-grade Flutter applications. This guide captures every convention and pattern used in this codebase and can be applied to any new Flutter project.

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Folder Structure](#2-folder-structure)
3. [Core Layer](#3-core-layer)
4. [Domain Layer](#4-domain-layer)
5. [Data Layer](#5-data-layer)
6. [Presentation Layer](#6-presentation-layer)
7. [State Management (BLoC)](#7-state-management-bloc)
8. [Cross-BLoC Communication (AppEventBus)](#8-cross-bloc-communication-appeventbus)
9. [Dependency Injection (GetIt)](#9-dependency-injection-getit)
10. [Routing (GoRouter)](#10-routing-gorouter)
11. [Database (Floor / SQLite)](#11-database-floor--sqlite)
12. [Error Handling](#12-error-handling)
13. [Theming](#13-theming)
14. [Shared Components](#14-shared-components)
15. [UI/UX Patterns](#15-uiux-patterns)
16. [Widget Refactoring Principles](#16-widget-refactoring-principles)
17. [Testing Strategy](#17-testing-strategy)
18. [Key Dependencies](#18-key-dependencies)
19. [Bootstrapping a New Project](#19-bootstrapping-a-new-project)
20. [Decision Reference Card](#20-decision-reference-card)

---

## 1. Architecture Overview

This architecture follows **Clean Architecture** principles with a **feature-driven** folder organisation. Dependency arrows always point inward — outer layers depend on inner layers, never the reverse.

```
┌──────────────────────────────────────────┐
│            Presentation Layer            │  ← BLoCs, Pages, Widgets
│  (depends on Domain; never on Data)      │
├──────────────────────────────────────────┤
│               Domain Layer               │  ← Entities, Repositories (interfaces), Use Cases
│         (pure Dart, zero Flutter)        │
├──────────────────────────────────────────┤
│               Data Layer                 │  ← Models, Data Sources, Repository Impls
│   (implements Domain; knows about DBs,   │
│    HTTP, SharedPreferences, etc.)        │
└──────────────────────────────────────────┘
           ↑ all layers reference ↑
┌──────────────────────────────────────────┐
│                Core Layer                │  ← DI, Routing, DB, EventBus, Error, Theme
└──────────────────────────────────────────┘
```

**Guiding Principles**
- Features are self-contained vertical slices.
- Shared code lives in `lib/features/shared/` (entities) or `lib/core/` (infrastructure).
- BLoCs communicate indirectly through `AppEventBus`; they never hold references to each other.
- All fallible operations return `Either<AppException, T>` from `dartz`.

---

## 2. Folder Structure

```
lib/
├── main.dart                    # Entry point
│
├── config/
│   ├── routes/
│   │   └── app_router.dart      # GoRouter configuration
│   └── theme/
│       └── app_theme.dart       # Light / dark ThemeData
│
├── core/
│   ├── api/                     # Dio + ApiClient wrapper
│   ├── db/
│   │   ├── app_database.dart    # Floor database definition
│   │   ├── dao/                 # DAO interfaces
│   │   └── converter/           # Floor type converters
│   ├── di/
│   │   └── service_locator.dart # GetIt registration
│   ├── error/
│   │   └── exceptions.dart      # AppException hierarchy
│   ├── event/
│   │   └── app_event_bus.dart   # Singleton broadcast stream
│   ├── extensions/              # Dart extension methods
│   ├── network/
│   │   └── network_info.dart    # Connectivity wrapper
│   ├── services/
│   │   ├── app_service.dart     # Service initialisation
│   │   └── user_settings_service.dart
│   └── util/                    # Generic utilities
│
├── features/
│   ├── shared/
│   │   ├── domain/
│   │   │   └── entities/        # Core business entities (pure Dart)
│   │   ├── data/
│   │   │   └── models/          # Floor models used across features
│   │   └── presentation/
│   │       └── widgets/         # Reusable UI components
│   │
│   └── {feature_name}/
│       ├── domain/
│       │   ├── entities/        # Feature-specific entities
│       │   ├── repositories/    # Abstract repository interfaces
│       │   └── usecases/        # Application use cases
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── local/       # Floor / SharedPreferences
│       │   │   └── remote/      # Dio HTTP
│       │   ├── models/          # Feature-specific Floor models
│       │   └── repositories/    # Repository implementations
│       └── presentation/
│           ├── blocs/           # BLoC, events, states (parts)
│           ├── pages/           # Full-screen route targets
│           ├── widgets/         # Feature-scoped widgets
│           └── utils/           # Feature-scoped utilities
│
└── scripts/
    └── create_feature.sh        # Scaffold a new feature skeleton
```

### Generating a new feature

```bash
./scripts/create_feature.sh
# Prompts: "Enter feature name:" → e.g. "order_history"
```

The script creates all required directories with `.gitkeep` placeholders so the structure is immediately visible in version control.

---

## 3. Core Layer

### 3.1 Entry Point (`main.dart`)

Initialise in order:
1. `WidgetsFlutterBinding.ensureInitialized()`
2. Device orientation preferences
3. Floor database (`$FloorAppDatabase.databaseBuilder(...).build()`)
4. GetIt service locator (`initServiceLocator(database)`)
5. Application services (`initAppServices()`)
6. `runApp()`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([...]);

  final database = await $FloorAppDatabase
      .databaseBuilder('app.db')
      .build();

  await initServiceLocator(database);
  await initAppServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
```

### 3.2 AppEventBus

A singleton broadcast `StreamController` that decouples BLoCs.

```dart
abstract class AppEvent {}

class AppEventBus {
  static final AppEventBus _instance = AppEventBus._internal();
  factory AppEventBus() => _instance;
  AppEventBus._internal();

  final _controller = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  void fire(AppEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}
```

### 3.3 Error / Exceptions

All custom exceptions extend `AppException`, which extends both `Exception` and `Equatable`.

```dart
class AppException extends Equatable implements Exception {
  final String message;
  final int? code;
  const AppException({required this.message, this.code});
  @override List<Object?> get props => [message, code];
}

class ServerException     extends AppException { ... }
class CacheException      extends AppException { ... }
class NetworkException    extends AppException { ... }
class ValidationException extends AppException { ... }
```

### 3.4 Network Info

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

### 3.5 API Client (Dio)

```dart
class ApiClient {
  final Dio _dio;
  final String _baseUrl;

  ApiClient({required Dio dio, required String baseUrl})
      : _dio = dio, _baseUrl = baseUrl;

  // Use _baseUrl to prefix all request paths.
  // Add interceptors on the Dio instance (in service_locator.dart) for
  // auth headers, logging, and retry logic.
}
```

---

## 4. Domain Layer

The domain layer is **pure Dart**. It has zero dependencies on Flutter, floor, dio, or any other infrastructure package.

### 4.1 Entities

Entities represent core business objects. They extend `Equatable` and use immutable fields with `copyWith`.

```dart
class Category extends Equatable {
  final int? id;
  final String name;
  final String? imageUri;

  const Category({this.id, required this.name, this.imageUri});

  Category copyWith({int? id, String? name, String? imageUri}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUri: imageUri ?? this.imageUri,
      );

  @override
  List<Object?> get props => [id, name, imageUri];
}
```

### 4.2 Repository Interfaces

Declare what data operations are possible. Implementation details live in the data layer.

```dart
abstract class CategoryRepository {
  Future<Either<AppException, List<Category>>> getCategories();
  Future<Either<AppException, Category>> addCategory(Category category);
  Future<Either<AppException, Category>> updateCategory(Category category);
  Future<Either<AppException, void>> deleteCategory(int id);
}
```

### 4.3 Use Cases

**Single Responsibility**: each use case represents one business purpose.

**Consolidation Rule**: when multiple operations serve *the same* business purpose (e.g. add-one vs add-many), merge them into a single class with multiple callable methods rather than creating separate classes.

```dart
// ✅ Consolidated use case
class AddCategoryUsecase {
  final CategoryRepository repository;
  AddCategoryUsecase(this.repository);

  /// Add a single category
  Future<Either<AppException, Category>> call(Category category) =>
      repository.addCategory(category);

  /// Add multiple categories in one operation
  Future<Either<AppException, List<Category>>> addMultiple(
      List<Category> categories) =>
      repository.addMultipleCategories(categories);
}

// ❌ Unnecessary: separate use case for the same business purpose
class AddMultipleCategoriesUsecase { ... }
```

Invoke use cases directly as callables:

```dart
final result = await addCategoryUsecase(category);          // single
final result = await addCategoryUsecase.addMultiple(list);  // bulk
```

---

## 5. Data Layer

### 5.1 Models (Floor entities)

Models are Floor-annotated database entities. They mirror domain entities plus persistence annotations.

```dart
@Entity(tableName: 'categories')
class CategoryModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'name')
  final String name;

  @ColumnInfo(name: 'image_uri')
  final String? imageUri;

  const CategoryModel({this.id, required this.name, this.imageUri});

  // Convert to/from domain entity
  factory CategoryModel.fromEntity(Category category) => CategoryModel(
        id: category.id, name: category.name, imageUri: category.imageUri);

  Category toEntity() =>
      Category(id: id, name: name, imageUri: imageUri);
}
```

**Models for shared entities** (used by multiple features) live in `lib/features/shared/data/models/`.

### 5.2 Type Converters

Register in `AppDatabase` with `@TypeConverters`. Provide converters for non-primitive types (DateTime, enums, etc.).

```dart
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) =>
      DateTime.fromMillisecondsSinceEpoch(databaseValue);

  @override
  int encode(DateTime value) => value.millisecondsSinceEpoch;
}
```

### 5.3 DAOs

```dart
@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories')
  Future<List<CategoryModel>> getAllCategories();

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<CategoryModel?> getCategoryById(int id);

  @insert
  Future<int> insertCategory(CategoryModel category);

  @update
  Future<void> updateCategory(CategoryModel category);

  @Query('DELETE FROM categories WHERE id = :id')
  Future<void> deleteCategoryById(int id);
}
```

### 5.4 Data Sources

Define an abstract interface and a concrete implementation per persistence mechanism.

```dart
abstract class CategoryDataSource {
  Future<List<Category>> getCategories();
  Future<Category> addCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(int id);
}

class CategoryLocalDataSourceImpl implements CategoryDataSource {
  final CategoryDao _categoryDao;
  CategoryLocalDataSourceImpl({required CategoryDao categoryItemDao})
      : _categoryDao = categoryItemDao;

  @override
  Future<List<Category>> getCategories() async {
    final models = await _categoryDao.getAllCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  // ... other methods
}
```

### 5.5 Repository Implementations

Implement domain repository interfaces. Wrap exceptions into `Either` using `try/catch`.

```dart
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;
  CategoryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<AppException, List<Category>>> getCategories() async {
    try {
      final categories = await dataSource.getCategories();
      return Right(categories);
    } on CacheException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }
}
```

---

## 6. Presentation Layer

### 6.1 Page Structure

Every page registers its own `BLocProvider` through a static `create()` factory method. This keeps instantiation logic co-located with the widget.

```dart
class CategoryPage extends StatelessWidget {
  static const routePath = '/categories';

  const CategoryPage({super.key});

  // Factory creates the BLoC and triggers initial load
  static Widget create() {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
      child: const CategoryPage(),
    );
  }

  @override
  Widget build(BuildContext context) { ... }
}
```

When a page needs a parameter (e.g. an ID from the route):

```dart
static Widget create({required int id}) {
  return BlocProvider(
    create: (_) => sl<SomeBloc>()..add(LoadDataEvent(id: id)),
    child: const SomePage(),
  );
}
```

### 6.2 Reading the BLoC in child widgets

```dart
// Dispatch an event
context.read<CategoryBloc>().add(DeleteCategoryEvent(id: category.id));

// Listen to state
BlocBuilder<CategoryBloc, CategoryState>(
  builder: (context, state) {
    if (state is CategoryLoading) return const CircularProgressIndicator();
    if (state is CategoryLoaded)  return _buildList(state.categories);
    if (state is CategoryError)   return Text(state.message);
    return const SizedBox.shrink();
  },
);
```

---

## 7. State Management (BLoC)

### 7.1 File layout

Use `part` directives so event/state files stay tightly coupled to their BLoC while remaining in separate files.

```
blocs/
└── category_bloc.dart       ← BLoC class  (imports everything)
    category_event.dart      ← part of category_bloc.dart
    category_state.dart      ← part of category_bloc.dart
```

```dart
// category_bloc.dart
import ...
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> { ... }

// category_event.dart
part of 'category_bloc.dart';
abstract class CategoryEvent extends Equatable { ... }

// category_state.dart
part of 'category_bloc.dart';
abstract class CategoryState extends Equatable { ... }
```

### 7.2 Standard state variants

Every BLoC should have at minimum:

| State | When emitted |
|---|---|
| `XxxInitialState` | Before any event is processed |
| `XxxLoadingState` | During an async fetch (only when no data is cached) |
| `XxxLoadedState`  | Successful data load; holds the payload |
| `XxxErrorState`   | Any failure; holds an error message string |

```dart
abstract class CategoryState extends Equatable {
  const CategoryState();
  @override List<Object?> get props => [];
}

class CategoryInitial  extends CategoryState {}
class CategoryLoading  extends CategoryState {}
class CategoryError    extends CategoryState {
  final String message;
  const CategoryError(this.message);
  @override List<Object> get props => [message];
}
class CategoryLoaded   extends CategoryState {
  final List<Category> categories;
  const CategoryLoaded(this.categories);
  @override List<Object> get props => [categories];
}
```

### 7.3 Efficient CRUD state updates (no loading flicker)

For add / update / delete operations on *already-loaded* data, update the in-memory list directly instead of re-emitting a loading state. This prevents jarring UI transitions.

```dart
Future<void> _onAddCategory(
    AddCategoryEvent event, Emitter<CategoryState> emit) async {
  // ❌ AVOID: emit(CategoryLoading()) — causes UI flicker

  final result = await addCategoryUsecase(event.category);
  result.fold(
    (failure) => emit(CategoryError(failure.toString())),
    (newCategory) {
      if (state is CategoryLoaded) {
        final current = state as CategoryLoaded;
        emit(CategoryLoaded([...current.categories, newCategory]));
      } else {
        add(LoadCategoriesEvent()); // fallback: full reload
      }
    },
  );
}
```

```dart
Future<void> _onDeleteCategory(
    DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
  final result = await deleteCategoryUsecase(event.id);
  result.fold(
    (failure) => emit(CategoryError(failure.toString())),
    (_) {
      if (state is CategoryLoaded) {
        final current = state as CategoryLoaded;
        emit(CategoryLoaded(
          current.categories.where((c) => c.id != event.id).toList(),
        ));
      }
    },
  );
}
```

**Rule**: only emit `XxxLoadingState` when the screen has *no data yet* (initial load). Skip it for mutations.

### 7.4 Events implementing AppEvent (cross-BLoC broadcasting)

When a BLoC event should be observed by *other* BLoCs, make it implement `AppEvent`.

```dart
class AddCategoryEvent extends CategoryEvent implements AppEvent {
  final Category category;
  const AddCategoryEvent({required this.category});
  @override List<Object> get props => [category];
}
```

The BLoC fires the event onto the bus *after* it has been processed successfully:

```dart
_onAddCategory(...) async {
  final result = await addCategoryUsecase(event.category);
  result.fold(
    (failure) => emit(CategoryError(...)),
    (newCategory) {
      _eventBus.fire(event); // broadcast to listeners
      // ... update local state
    },
  );
}
```

---

## 8. Cross-BLoC Communication (AppEventBus)

Use `AppEventBus` when one BLoC needs to react to something that happened in another BLoC without a direct import relationship.

### 8.1 Subscribing

```dart
class PurchaseListBloc extends Bloc<...> {
  late final StreamSubscription _sub;

  PurchaseListBloc({required AppEventBus eventBus, ...}) : super(...) {
    on<...>(...);

    _sub = eventBus.stream.listen((event) {
      if (event is AddCategoryEvent) {
        add(RefreshEvent()); // react to cross-feature changes
      }
    });
  }

  @override
  Future<void> close() {
    _sub.cancel(); // ALWAYS cancel
    return super.close();
  }
}
```

### 8.2 Rules

| Rule | Rationale |
|---|---|
| Always cancel subscriptions in `close()` | Prevents memory leaks |
| BLoCs must never import each other | Enforces loose coupling |
| Only fire events *after* successful persistence | Listeners assume data is already saved |
| Keep fired events lightweight (the BLoC event itself is usually enough) | Avoids duplicating payload |

---

## 9. Dependency Injection (GetIt)

All registrations live in one file: `lib/core/di/service_locator.dart`.

### 9.1 Registration rules

| Type | GetIt registration | Rationale |
|---|---|---|
| BLoC | `registerFactory` | New instance per `BlocProvider`; avoids shared mutable state |
| Use Case | `registerLazySingleton` | Stateless; can be shared |
| Repository | `registerLazySingleton` | Stateless; can be shared |
| Data Source | `registerLazySingleton` | Stateless; wraps DAO/HTTP |
| Service | `registerLazySingleton` | Cached app-wide state |
| External (Dio, SharedPrefs) | `registerLazySingleton` | Single configured instance |

### 9.2 Registration order

```
Core infra (Connectivity, Dio, SharedPrefs)
  → Data Sources
  → Repositories
  → Use Cases
  → Services
  → BLoCs (factories, listed last)
```

### 9.3 Example

```dart
final sl = GetIt.instance;

Future<void> initServiceLocator(AppDatabase database) async {
  // Infrastructure
  sl.registerLazySingleton(() => AppEventBus());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiClient>(
      () => ApiClient(dio: sl(), baseUrl: 'https://api.example.com'));

  // Data sources
  sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryLocalDataSourceImpl(categoryItemDao: database.categoryDao));

  // Repositories
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(dataSource: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => AddCategoryUsecase(sl()));

  // Services
  sl.registerLazySingleton(() => UserSettingsService(getUserSettingsUsecase: sl()));

  // BLoCs — always factories
  sl.registerFactory(() => CategoryBloc(
        getCategoriesUsecase: sl(),
        addCategoryUsecase: sl(),
      ));
}
```

### 9.4 Accessing registered instances

```dart
sl<CategoryBloc>()          // new instance (factory)
sl<CategoryRepository>()    // same instance (lazy singleton)
```

---

## 10. Routing (GoRouter)

### 10.1 Router setup

```dart
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: HomePage.routePath,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: HomePage.routePath,
              builder: (_, __) => HomePage.create(),
            ),
          ]),
          // ... more branches
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
```

### 10.2 Nested routes with parameters

```dart
GoRoute(
  path: '${ListPage.routePath}/:listId',
  parentNavigatorKey: _rootNavigatorKey, // pushes above bottom nav
  builder: (context, state) {
    final id = int.tryParse(state.pathParameters['listId'] ?? '');
    if (id == null) throw Exception('Invalid ID');
    return EditorPage.create(id: id);
  },
),
```

### 10.3 Conventions

- Each page declares `static const routePath = '/path'`.
- Path parameters are parsed as typed values immediately in the builder; throw if invalid.
- Use `parentNavigatorKey: _rootNavigatorKey` for pages that should display *over* the bottom navigation shell.
- Use `NoTransitionPage` for tab switches that should not animate.

```dart
pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
```

### 10.4 Navigation

```dart
context.push('/lists/editor/42');   // push onto stack
context.go('/lists');               // replace stack
context.pop();                      // back
```

---

## 11. Database (Floor / SQLite)

### 11.1 Database class

```dart
@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Database(version: 1, entities: [CategoryModel, ItemModel, ...])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;
  ItemDao get itemDao;
}
```

### 11.2 Code generation

Run after any model/DAO change:

```bash
flutter packages pub run build_runner build
# or for watch mode:
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

### 11.3 Migration (version bump)

```dart
@Database(version: 2, entities: [...])
abstract class AppDatabase extends FloorDatabase {
  static final migration1to2 = Migration(1, 2, (database) async {
    await database.execute('ALTER TABLE categories ADD COLUMN color TEXT');
  });
}

// In main.dart:
$FloorAppDatabase
    .databaseBuilder('app.db')
    .addMigrations([AppDatabase.migration1to2])
    .build();
```

### 11.4 Relationship queries

Floor does not natively support relationships. Build composite result DTOs in the DAO using raw SQL and map them manually in the data source.

---

## 12. Error Handling

### 12.1 Use case error propagation

```dart
Future<Either<AppException, Category>> call(Category category) async {
  try {
    final result = await _repository.addCategory(category);
    return result; // repository already returns Either
  } catch (e) {
    return Left(AppException(message: e.toString()));
  }
}
```

### 12.2 Consuming errors in BLoC

```dart
final result = await addCategoryUsecase(event.category);
result.fold(
  (failure) => emit(CategoryError(failure.message)),
  (category) => /* update state */,
);
```

### 12.3 User feedback

Use a centralised toast utility rather than `SnackBar` calls scattered across widgets.

```dart
class AppToast {
  static void showSuccess(BuildContext context, String message) { ... }
  static void showError(BuildContext context, String message) { ... }
}
```

Call from `BlocListener`:

```dart
BlocListener<CategoryBloc, CategoryState>(
  listener: (context, state) {
    if (state is CategoryError) {
      AppToast.showError(context, state.message);
    }
  },
  child: ...,
)
```

---

## 13. Theming

### 13.1 Structure

```dart
class AppTheme {
  AppTheme._(); // non-instantiable

  static const Color primaryColor   = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF2E7D32);
  static const Color errorColor     = Color(0xFFD32F2F);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    ),
    // centralised component themes:
    appBarTheme: ...,
    cardTheme: ...,
    elevatedButtonTheme: ...,
    floatingActionButtonTheme: ...,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(...),
    // ...
  );
}
```

### 13.2 Consuming theme

Always read colours from `Theme.of(context).colorScheme` in widgets; never hard-code hex values in widget files.

```dart
color: Theme.of(context).colorScheme.primary
```

---

## 14. Shared Components

### 14.1 Entities (`lib/features/shared/domain/entities/`)

Place entities that are *referenced by more than one feature* here (e.g. `Category`, `CatalogItem`).

### 14.2 Models (`lib/features/shared/data/models/`)

Corresponding Floor models for shared entities.

### 14.3 Widgets (`lib/features/shared/presentation/widgets/`)

Reusable Flutter widgets consumed across features:

| Widget | Purpose |
|---|---|
| `AppBottomSheet` | Standardised bottom sheet with keyboard inset handling |
| `AppToast` | Consistent success / error messages |

**AppBottomSheet usage patterns:**

```dart
// Form-based (validation + submit)
AppBottomSheet.form(
  title: 'Add Item',
  formKey: _formKey,
  formFields: [_nameField(), _priceField()],
  onSubmit: _handleSubmit,
);

// Custom interactive content
AppBottomSheet.show(
  context: context,
  child: MyCustomSheet(onConfirm: _handleConfirm),
);
```

**Keyboard-safe content layout:**

```dart
AppBottomSheet(
  content: Padding(
    padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.3),
        child: Column(children: [...]),
      ),
    ),
  ),
)
```

> Use `ConstrainedBox`—not `Expanded`—inside bottom sheets to prevent keyboard overflow.

---

## 15. UI/UX Patterns

### 15.1 StatefulShellRoute bottom navigation

```dart
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: const [...],
      ),
    );
  }
}
```

### 15.2 Tappable list items for inline editing

```dart
ListTile(
  title: Text(item.name),
  subtitle: Text('${item.quantity} pcs'),
  trailing: IconButton(
    icon: const Icon(Icons.delete_outline),
    onPressed: () => context.read<SomeBloc>().add(DeleteItemEvent(id: item.id)),
  ),
  onTap: () => ItemFormBottomSheet.showEdit(context, item),
)
```

### 15.3 Service — non-BLoC global state

For simple global values that don't need reactive UI (e.g. currency symbol), create a plain service class registered as a lazy singleton. Access it synchronously anywhere.

```dart
class UserSettingsService {
  static UserSettingsService get instance => sl<UserSettingsService>();

  String get defaultCurrency => _settings?.defaultCurrency ?? '\$';

  Future<void> initialize() async { ... }
}
```

---

## 16. Widget Refactoring Principles

### 16.1 Unified form widgets

When add and edit operations share the same form fields/validation, use **one widget** driven by a configuration object.

```dart
// Configuration
class ItemFormConfig {
  final String title;
  final Item? initialItem;         // null → add mode
  final String successMessage;

  factory ItemFormConfig.forAdd() => const ItemFormConfig(
        title: 'Add Item', initialItem: null, successMessage: 'Item added');

  factory ItemFormConfig.forEdit(Item item) => ItemFormConfig(
        title: 'Edit Item', initialItem: item, successMessage: 'Item updated');
}

// Widget
class ItemFormBottomSheet extends StatefulWidget {
  final ItemFormConfig config;

  factory ItemFormBottomSheet.forAdd() =>
      ItemFormBottomSheet(config: ItemFormConfig.forAdd());

  factory ItemFormBottomSheet.forEdit(Item item) =>
      ItemFormBottomSheet(config: ItemFormConfig.forEdit(item));

  static Future<void> showAdd(BuildContext context) =>
      showModalBottomSheet(context: context,
          builder: (_) => ItemFormBottomSheet.forAdd());

  static Future<void> showEdit(BuildContext context, Item item) =>
      showModalBottomSheet(context: context,
          builder: (_) => ItemFormBottomSheet.forEdit(item));
}
```

### 16.2 Extracting utilities

Move icon parsing, validation helpers, and format helpers into a feature-scoped `utils/` class so the widget stays lean.

```dart
class CategoryIconUtils {
  static IconData? parseIconFromUri(String? uri) { ... }
  static String? iconToUri(IconData? icon) { ... }
}
```

### 16.3 When to refactor

Refactor into a unified pattern when two or more widgets share **>50% identical code**. Prefer a slight up-front investment in configuration objects over copy-pasted widgets.

---

## 17. Testing Strategy

### 17.1 BLoC unit tests (`bloc_test`)

```dart
blocTest<CategoryBloc, CategoryState>(
  'emits [CategoryLoaded] when LoadCategoriesEvent is added',
  build: () {
    when(mockGetCategoriesUsecase()).thenAnswer((_) async => Right(fakeCategories));
    return CategoryBloc(getCategoriesUsecase: mockGetCategoriesUsecase, ...);
  },
  act: (bloc) => bloc.add(LoadCategoriesEvent()),
  expect: () => [
    CategoryLoading(),
    CategoryLoaded(fakeCategories),
  ],
);
```

### 17.2 Use case unit tests

```dart
test('returns Right<Category> on success', () async {
  when(mockRepository.addCategory(any)).thenAnswer((_) async => Right(fakeCategory));
  final result = await usecase(fakeCategory);
  expect(result, Right(fakeCategory));
});
```

### 17.3 AppEventBus integration tests

```dart
test('BlocA triggers BlocB refresh via event bus', () async {
  final bus = AppEventBus();
  final blocB = BlocB(eventBus: bus, ...);

  bus.fire(SomeEvent());
  await Future.delayed(Duration.zero);

  expect(blocB.state, isA<LoadedState>());
});
```

### 17.4 Mock setup (mockito)

```dart
@GenerateMocks([CategoryRepository, GetCategoriesUsecase])
void main() { ... }
// Run: flutter pub run build_runner build
```

---

## 18. Key Dependencies

```yaml
dependencies:
  # State management
  flutter_bloc: ^9.x
  equatable: ^2.x

  # Routing
  go_router: ^15.x

  # Local storage
  floor: ^1.x
  shared_preferences: ^2.x

  # Network
  dio: ^5.x
  connectivity_plus: ^6.x

  # Dependency injection
  get_it: ^8.x

  # Functional programming
  dartz: ^0.10.x

  # UI utilities
  flutter_svg: ^2.x
  intl: ^0.20.x

dev_dependencies:
  floor_generator: ^1.x
  build_runner: ^2.x
  bloc_test: ^10.x
  mockito: ^5.x
```

---

## 19. Bootstrapping a New Project

Follow these steps to apply this architecture to a fresh Flutter project.

### Step 1 — Create the folder skeleton

```bash
mkdir -p lib/{config/{routes,theme},core/{api,db/{dao,converter},di,error,event,extensions,network,services,util}}
mkdir -p lib/features/shared/{domain/entities,data/models,presentation/widgets}
mkdir -p scripts
```

### Step 2 — Add the `create_feature.sh` script

```bash
cat > scripts/create_feature.sh << 'EOF'
#!/usr/bin/env bash
read -p "Enter feature name: " feature

mkdir -p "./lib/features/$feature/domain/entities"
mkdir -p "./lib/features/$feature/domain/repositories"
mkdir -p "./lib/features/$feature/domain/usecases"
mkdir -p "./lib/features/$feature/data/datasources/local"
mkdir -p "./lib/features/$feature/data/datasources/remote"
mkdir -p "./lib/features/$feature/data/models"
mkdir -p "./lib/features/$feature/data/repositories"
mkdir -p "./lib/features/$feature/presentation/blocs"
mkdir -p "./lib/features/$feature/presentation/pages"
mkdir -p "./lib/features/$feature/presentation/widgets"
mkdir -p "./lib/features/$feature/presentation/utils"

find "./lib/features/$feature" -type d -exec touch {}/.gitkeep \;

echo "Feature '$feature' created."
EOF
chmod +x scripts/create_feature.sh
```

### Step 3 — Install dependencies

Add all packages from Section 18 to `pubspec.yaml`, then:

```bash
flutter pub get
```

### Step 4 — Create core files

Create these files in order (each depends on the previous):

1. `lib/core/error/exceptions.dart` — `AppException` hierarchy
2. `lib/core/event/app_event_bus.dart` — singleton broadcast bus
3. `lib/core/network/network_info.dart` — connectivity wrapper
4. `lib/core/db/app_database.dart` — Floor database shell
5. `lib/core/di/service_locator.dart` — GetIt registrations (fill in as features are added)
6. `lib/config/theme/app_theme.dart` — `AppTheme.lightTheme` / `darkTheme`
7. `lib/config/routes/app_router.dart` — GoRouter with initial shell
8. `lib/main.dart` — bootstrapping sequence

### Step 5 — Add your first feature

```bash
./scripts/create_feature.sh   # Enter: "todo"
```

Then implement in layer order:
1. `domain/entities/todo.dart`
2. `domain/repositories/todo_repository.dart` (interface)
3. `domain/usecases/get_todos_usecase.dart`
4. `data/models/todo_model.dart` (Floor entity)
5. `core/db/dao/todo_dao.dart`
6. Register `TodoModel` in `AppDatabase`; run `build_runner`
7. `data/datasources/local/todo_local_data_source.dart`
8. `data/repositories/todo_repository_impl.dart`
9. `presentation/blocs/todo_bloc.dart` + `_event.dart` + `_state.dart`
10. Register everything in `service_locator.dart`
11. `presentation/pages/todo_page.dart` (with static `create()`)
12. Add route in `app_router.dart`

### Step 6 — Run code generation

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 20. Decision Reference Card

Quick answers to common "which way do I go?" questions.

| Question | Answer |
|---|---|
| Two BLoCs need to communicate | Use `AppEventBus`; never import one BLoC in another |
| Add vs Edit share same form | Unified widget with `ItemFormConfig.forAdd()` / `.forEdit()` |
| Add/Edit/Delete on loaded list | Update list in-memory; skip loading state |
| Single vs bulk operation | Consolidate into one use case with multiple methods |
| Persistent app-wide value (no UI reactivity) | Plain service class, lazy singleton in GetIt |
| Reactive app-wide value | BLoC + `AppEventBus` subscription |
| Navigating above bottom nav | Add `parentNavigatorKey: _rootNavigatorKey` to `GoRoute` |
| Entity update | Use `copyWith`; never mutate directly |
| New feature | Run `create_feature.sh`; implement domain → data → presentation |
| Models for >1 feature | Place in `lib/features/shared/data/models/` |
| Entities for >1 feature | Place in `lib/features/shared/domain/entities/` |
| Background work result | Return `Either<AppException, T>` via `dartz` |
| DAO for non-primitive type | Write a Floor `TypeConverter` |
| DB schema change | Increment version; write a `Migration` |
| BLoC registration in GetIt | Always `registerFactory`; never `registerSingleton` |
| Service/Repository in GetIt | Always `registerLazySingleton` |
