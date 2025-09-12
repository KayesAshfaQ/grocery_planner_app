import 'package:intl/intl.dart';

/// Extension methods for DateTime to provide convenient formatting and utilities
extension DateTimeExtension on DateTime {
  /// Returns the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns the start of the week (Monday 00:00:00)
  DateTime get startOfWeek {
    final weekday = this.weekday;
    final daysToSubtract = weekday - 1; // Monday = 1
    return subtract(Duration(days: daysToSubtract)).startOfDay;
  }

  /// Returns the start of the month (first day 00:00:00)
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns the start of the year (January 1st 00:00:00)
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Format for UI display - "Sep 12, 2025"
  String get displayDate => DateFormat('MMM dd, yyyy').format(this);

  /// Format for UI display with time - "Sep 12, 2025 at 3:30 PM"
  String get displayDateTime =>
      DateFormat('MMM dd, yyyy \'at\' h:mm a').format(this);

  /// Compact format - "12/09/2025"
  String get compactDate => DateFormat('dd/MM/yyyy').format(this);

  /// Short format - "Sep 12"
  String get shortDate => DateFormat('MMM dd').format(this);

  /// Time format - "3:30 PM"
  String get timeFormat => DateFormat('h:mm a').format(this);

  /// Relative time format - "2 days ago", "Today", "Yesterday"
  String get relativeTime {
    final now = DateTime.now();
    final today = now.startOfDay;
    final yesterday = today.subtract(const Duration(days: 1));
    final thisDate = startOfDay;

    if (thisDate == today) {
      return 'Today';
    } else if (thisDate == yesterday) {
      return 'Yesterday';
    } else if (isAfter(now.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE').format(this); // "Monday"
    } else if (year == now.year) {
      return DateFormat('MMM dd').format(this); // "Sep 12"
    } else {
      return DateFormat('MMM dd, yyyy').format(this); // "Sep 12, 2023"
    }
  }

  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if the date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.startOfWeek;
    final endOfWeek = startOfWeek.add(const Duration(days: 6)).endOfDay;
    return isAfter(startOfWeek.subtract(const Duration(milliseconds: 1))) &&
        isBefore(endOfWeek.add(const Duration(milliseconds: 1)));
  }

  /// Check if the date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Get milliseconds since epoch for database storage
  int get epochMilliseconds => millisecondsSinceEpoch;

  /// Create DateTime from epoch milliseconds
  static DateTime fromEpochMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);
}

/// Utility class for common DateTime operations
class DateTimeUtils {
  /// Get start of today in milliseconds (for database queries)
  static int get todayStartMillis =>
      DateTime.now().startOfDay.epochMilliseconds;

  /// Get start of this week in milliseconds (for database queries)
  static int get weekStartMillis =>
      DateTime.now().startOfWeek.epochMilliseconds;

  /// Get start of this month in milliseconds (for database queries)
  static int get monthStartMillis =>
      DateTime.now().startOfMonth.epochMilliseconds;

  /// Get start of this year in milliseconds (for database queries)
  static int get yearStartMillis =>
      DateTime.now().startOfYear.epochMilliseconds;

  /// Get date range for today (start and end in milliseconds)
  static ({int start, int end}) get todayRange {
    final today = DateTime.now().startOfDay;
    return (
      start: today.epochMilliseconds,
      end: today.endOfDay.epochMilliseconds,
    );
  }

  /// Get date range for this week (start and end in milliseconds)
  static ({int start, int end}) get weekRange {
    final startOfWeek = DateTime.now().startOfWeek;
    final endOfWeek = startOfWeek.add(const Duration(days: 6)).endOfDay;
    return (
      start: startOfWeek.epochMilliseconds,
      end: endOfWeek.epochMilliseconds,
    );
  }

  /// Get date range for this month (start and end in milliseconds)
  static ({int start, int end}) get monthRange {
    final now = DateTime.now();
    final startOfMonth = now.startOfMonth;
    final endOfMonth = DateTime(now.year, now.month + 1, 0).endOfDay;
    return (
      start: startOfMonth.epochMilliseconds,
      end: endOfMonth.epochMilliseconds,
    );
  }

  /// Create a custom date range in milliseconds
  static ({int start, int end}) createRange(DateTime start, DateTime end) {
    return (
      start: start.startOfDay.epochMilliseconds,
      end: end.endOfDay.epochMilliseconds,
    );
  }
}
