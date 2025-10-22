import 'package:floor/floor.dart';

class NullableDateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) {
    return databaseValue != null
        ? DateTime.fromMillisecondsSinceEpoch(databaseValue)
        : null;
  }

  @override
  int? encode(DateTime? value) {
    return value?.millisecondsSinceEpoch;
  }
}
