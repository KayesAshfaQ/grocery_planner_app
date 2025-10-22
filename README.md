# Grocery Planner App

A comprehensive grocery planning and tracking application built with Flutter using Clean Architecture.

## Project Overview

The Grocery Planner App helps users manage their grocery shopping with features like:

- Add grocery items to shopping lists with detailed information (name, quantity, price, category, notes)
- Schedule shopping trips with reminders
- Mark items as purchased with price tracking
- View weekly and monthly purchase reports
- Track price fluctuations over time with graphs
- Pre-registered grocery item database

## Architecture

This application is built using **Clean Architecture** principles, which separates the codebase into distinct layers with specific responsibilities.

### Directory Structure

```
lib/
├── config/                  # App configuration
│   ├── routes/              # Navigation routes
│   ├── theme/               # App theme
│   └── constants/           # App constants
├── core/                    # Core functionality 
│   ├── di/                  # Dependency injection setup
│   ├── error/               # Error handling
│   ├── event/               # Event bus for cross-BLoC communication
│   ├── network/             # Network handling
│   ├── theme/               # Themes configuration
│   └── util/                # Utility functions
├── data/                    # Data layer
│   ├── datasources/         # Data source interfaces
│   │   ├── local/           # Local data sources
│   │   └── remote/          # Remote data sources
│   ├── models/              # Data models
│   ├── repositories/        # Repository implementations
│   └── local/               # Local database implementation
├── domain/                  # Domain layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Business logic use cases
└── presentation/            # Presentation layer
    ├── blocs/               # BLoC state management
    ├── pages/               # UI screens
    └── widgets/             # Reusable UI components
```

## Clean Architecture

This project follows Clean Architecture principles with three main layers:

1. **Presentation Layer**: Contains UI components, screens, and state management (BLoC)
2. **Domain Layer**: Contains business logic, entities, and use cases
3. **Data Layer**: Handles data operations, API calls, and local storage

### Cross-Layer Communication

The application uses an **AppEventBus** for reactive communication between different BLoCs in the presentation layer, enabling loose coupling while maintaining clean architecture principles. This event-driven approach allows BLoCs to react to state changes in other parts of the application without creating direct dependencies.

### Dependencies

- **State Management**: flutter_bloc, bloc, equatable
- **Dependency Injection**: get_it, injectable
- **Navigation**: go_router
- **Database**: floor, sqflite
- **Network**: dio, connectivity_plus
- **Charts**: fl_chart
- **UI Components**: flutter_slidable, shimmer, table_calendar

## Key Features Implementation

### 1. Grocery Item Management

Users can add grocery items to their shopping list with:
- Name
- Quantity
- Unit price/total price
- Category
- Notes

#### Example Entity:

```dart
// Domain Entity
class GroceryItem extends Equatable {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final String category;
  final String note;
  final bool isPurchased;
  final DateTime createdAt;
  final DateTime? purchasedAt;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.category,
    this.note = '',
    this.isPurchased = false,
    required this.createdAt,
    this.purchasedAt,
  }) : totalPrice = unitPrice * quantity;

  @override
  List<Object?> get props => [id, name, quantity, unit, unitPrice, totalPrice, 
                             category, note, isPurchased, createdAt, purchasedAt];
}
```

### 2. Shopping Schedule Management

Users can schedule shopping trips with notifications:

#### Example Use Case:

```dart
// Domain Use Case
class ScheduleShoppingTrip {
  final ShoppingScheduleRepository repository;
  final NotificationService notificationService;

  ScheduleShoppingTrip(this.repository, this.notificationService);

  Future<Either<Failure, ShoppingSchedule>> call(
    DateTime scheduledDate, 
    String location, 
    String note
  ) async {
    final schedule = ShoppingSchedule(
      id: const Uuid().v4(),
      scheduledDate: scheduledDate,
      location: location,
      note: note,
      createdAt: DateTime.now(),
    );
    
    final result = await repository.addSchedule(schedule);
    
    result.fold(
      (failure) => null,
      (schedule) => notificationService.scheduleNotification(
        schedule.id,
        'Shopping Reminder',
        'Remember to visit ${schedule.location} today for shopping',
        schedule.scheduledDate,
      ),
    );
    
    return result;
  }
}
```

### 3. Reports and Analytics

View weekly and monthly reports of purchases:

#### Example BLoC:

```dart
// Presentation BLoC
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetWeeklyReport getWeeklyReport;
  final GetMonthlyReport getMonthlyReport;
  final GetPriceFluctuation getPriceFluctuation;

  ReportBloc({
    required this.getWeeklyReport,
    required this.getMonthlyReport,
    required this.getPriceFluctuation,
  }) : super(ReportInitial()) {
    on<FetchWeeklyReport>(_onFetchWeeklyReport);
    on<FetchMonthlyReport>(_onFetchMonthlyReport);
    on<FetchPriceFluctuation>(_onFetchPriceFluctuation);
  }

  Future<void> _onFetchWeeklyReport(
    FetchWeeklyReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    final result = await getWeeklyReport(event.startDate, event.endDate);
    result.fold(
      (failure) => emit(ReportError(message: _mapFailureToMessage(failure))),
      (report) => emit(WeeklyReportLoaded(report)),
    );
  }

  // Other event handlers...
}
```

## Event-Driven Architecture with AppEventBus

The application uses a custom **AppEventBus** for cross-BLoC communication, enabling loose coupling between different parts of the application while maintaining reactive state management.

### AppEventBus Overview

The `AppEventBus` is a singleton service that implements the Observer pattern using Dart streams to facilitate communication between different BLoCs without creating direct dependencies.

#### Key Features:
- **Singleton Pattern**: Ensures single instance across the app
- **Broadcast Stream**: Allows multiple listeners to subscribe to events
- **Type-Safe Events**: Uses abstract `AppEvent` base class for type safety
- **Memory Management**: Provides proper cleanup with `dispose()` method

#### Implementation:

```dart
/// Base class for all app events
abstract class AppEvent {}

/// A simple event bus for app-wide communication
class AppEventBus {
  // Singleton pattern
  static final AppEventBus _instance = AppEventBus._internal();
  factory AppEventBus() => _instance;
  AppEventBus._internal();

  // The broadcast stream controller that manages events
  final StreamController<AppEvent> _controller = StreamController<AppEvent>.broadcast();

  /// The stream of app events
  Stream<AppEvent> get stream => _controller.stream;

  /// Fire an event to all listeners
  void fire(AppEvent event) {
    _controller.add(event);
  }

  /// Dispose resources
  void dispose() {
    _controller.close();
  }
}
```

### Usage Patterns

#### 1. Event Definition
Events must implement the `AppEvent` interface and typically extend `PurchaseListEditorEvent`:

```dart
/// Event to add a new PurchaseList
class AddPurchaseListEvent extends PurchaseListEditorEvent implements AppEvent {
  final PurchaseList list;

  const AddPurchaseListEvent({required this.list});

  @override
  List<Object?> get props => [list];
}
```

#### 2. Publishing Events (Event Producer)
The `PurchaseListEditorBloc` fires events when significant operations complete:

```dart
class PurchaseListEditorBloc extends Bloc<PurchaseListEditorEvent, PurchaseListEditorState> {
  final AppEventBus _eventBus;

  // Constructor with dependency injection
  PurchaseListEditorBloc({
    // other dependencies...
    required AppEventBus eventBus,
  }) : _eventBus = eventBus, super(PurchaseListEditorInitialState());

  // Event handler that fires events to other BLoCs
  FutureOr<void> _onAddPurchaseList(
    AddPurchaseListEvent event,
    Emitter<PurchaseListEditorState> emit,
  ) async {
    emit(PurchaseListEditorLoadingState());
    final result = await addPurchaseListUsecase(event.list);
    
    result.fold(
      (failure) => emit(PurchaseListEditorErrorState(message: failure.toString())),
      (purchaseList) {
        // Notify other blocs about the new list through the event bus
        _eventBus.fire(event);

        // Emit success state to trigger UI feedback
        emit(PurchaseListAddedState(list: purchaseList));
      },
    );
  }
}
```

#### 3. Consuming Events (Event Subscriber)
The `PurchaseListBloc` subscribes to events and reacts accordingly:

```dart
class PurchaseListBloc extends Bloc<PurchaseListEvent, PurchaseListState> {
  final AppEventBus _eventBus;
  late final StreamSubscription _eventSubscription;

  PurchaseListBloc({
    // other dependencies...
    required AppEventBus eventBus,
  }) : _eventBus = eventBus, super(PurchaseListInitialState()) {
    
    // Subscribe to events from the event bus
    _eventSubscription = _eventBus.stream.listen((event) {
      if (event is AddPurchaseListEvent) {
        // Refresh the purchase list when a new list is added
        add(GetAllPurchaseItemsEvent());
      }
    });
  }

  @override
  Future<void> close() {
    // Clean up subscription to prevent memory leaks
    _eventSubscription.cancel();
    return super.close();
  }
}
```

#### 4. Dependency Injection Setup
The `AppEventBus` is registered as a lazy singleton in the service locator:

```dart
// In service_locator.dart
Future<void> initServiceLocator(AppDatabase database) async {
  // Register AppEventBus as singleton
  sl.registerLazySingleton(() => AppEventBus());

  // Register BLoCs with AppEventBus dependency
  sl.registerFactory(() => PurchaseListBloc(
    getAllPurchaseListUseCase: sl(),
    markItemAsPurchasedUsecase: sl(),
    eventBus: sl(), // Inject the singleton instance
  ));

  sl.registerFactory(() => PurchaseListEditorBloc(
    getCategoriesUsecase: sl(),
    getCatalogItemsUsecase: sl(),
    addPurchaseListUsecase: sl(),
    addPurchaseItemUsecase: sl(),
    removePurchaseItemUsecase: sl(),
    eventBus: sl(), // Inject the singleton instance
  ));
}
```

### Benefits of This Approach

1. **Loose Coupling**: BLoCs don't need direct references to each other
2. **Scalability**: Easy to add new event types and subscribers
3. **Testability**: Can mock the event bus for isolated testing
4. **Maintainability**: Clear separation of concerns
5. **Performance**: Broadcast streams are efficient for multiple listeners

### Best Practices

1. **Event Naming**: Use descriptive names ending with "Event"
2. **Memory Management**: Always cancel subscriptions in the `close()` method
3. **Error Handling**: Wrap event firing in try-catch blocks when necessary
4. **Documentation**: Document which events each BLoC produces and consumes
5. **Testing**: Create mock implementations for unit testing

## BLoC Usage Patterns

### When to Use `sl<Bloc>()..add()` vs `context.read<Bloc>().add()`

Understanding when to use each pattern is crucial for proper BLoC management in Flutter applications.

#### **`sl<Bloc>()..add()` - Creating New Instances**

**Use Case:** Creating a **new instance** of the bloc with initial setup

```dart
// ✅ Factory method for creating pages with new bloc instances
static Widget create({required String id}) {
  return BlocProvider(
    create: (context) => sl<PurchaseListEditorBloc>()..add(LoadInitialDataEvent(id: id)),
    child: const PurchaseListEditorPage(),
  );
}
```

**When to use:**
- In factory methods when creating pages
- When you need a fresh bloc instance
- During initial setup/dependency injection
- The bloc doesn't exist in the widget tree yet

**What it does:**
1. Creates a new bloc instance via service locator
2. Immediately adds an event to initialize the bloc
3. Usually wrapped in `BlocProvider.create()`

#### **`context.read<Bloc>().add()` - Using Existing Instances**

**Use Case:** Accessing an **existing bloc** from the widget tree

```dart
// ✅ User interaction with existing bloc instance
onPressed: () {
  context.read<PurchaseListEditorBloc>().add(
    RemoveItemFromPurchaseListEvent(id: item.id)
  );
}
```

**When to use:**
- Inside widget methods (like button onPressed callbacks)
- When the bloc already exists in the widget tree
- For user interactions and events
- When you need to trigger actions from UI components

**What it does:**
1. Finds the existing bloc in the widget tree
2. Adds an event to that existing instance
3. Throws error if bloc doesn't exist in tree

#### **Key Rule**

```dart
// ✅ CREATION: Use sl<>()..add() for bloc instantiation
BlocProvider(
  create: (context) => sl<SomeBloc>()..add(InitialEvent()),
  child: SomePage(),
)

// ✅ INTERACTION: Use context.read<>().add() for user actions
FloatingActionButton(
  onPressed: () => context.read<SomeBloc>().add(UserActionEvent()),
)
```

**Remember:** Use `sl<>()..add()` for **creation**, use `context.read<>().add()` for **interaction**.

### Current Event Flow

```
PurchaseListEditorBloc → AddPurchaseListEvent → AppEventBus → PurchaseListBloc
                      ↓                                      ↓
              (UI Updates with                    (Refreshes purchase list
               success feedback)                   to show new items)
```

This architecture ensures that when a user adds a new purchase list through the editor, the main purchase list view automatically refreshes to display the new data without requiring manual coordination between BLoCs.

## Getting Started

### Prerequisites