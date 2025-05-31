import 'dart:async';

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
