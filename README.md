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

## Getting Started

### Prerequisites