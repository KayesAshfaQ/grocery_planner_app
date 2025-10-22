extension DateTimeParsing on String {
  /// This method is used to parse a string into a local DateTime object.
  /// If the string cannot be parsed, it returns null.
  /// Usage: `myString.toLocalDateTime()`
  DateTime? toLocalDateTime() {
    try {
      return DateTime.parse(this).toLocal();
    } catch (_) {
      return null;
    }
  }
}
