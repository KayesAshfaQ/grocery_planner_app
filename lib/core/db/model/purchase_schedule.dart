import 'package:floor/floor.dart';

/// Database model for scheduled purchases
@Entity(tableName: 'purchase_schedules')
class PurchaseSchedule {
  /// Primary key identifier for the schedule
  @PrimaryKey(autoGenerate: true)
  final int? scheduleId;

  /// Foreign key reference to the purchase list this schedule is for
  @ColumnInfo(name: 'list_id')
  final int listId;

  /// The planned market date
  @ColumnInfo(name: 'market_date')
  final DateTime marketDate;

  /// Optional notification timestamp
  @ColumnInfo(name: 'notify_at')
  final DateTime? notifyAt;

  PurchaseSchedule({
    this.scheduleId,
    required this.listId,
    required this.marketDate,
    this.notifyAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'schedule_id': scheduleId,
      'list_id': listId,
      'market_date': marketDate.toIso8601String().split('T')[0], // Just the date part
      'notify_at': notifyAt?.toIso8601String(),
    };
  }

  factory PurchaseSchedule.fromMap(Map<String, dynamic> map) {
    return PurchaseSchedule(
      scheduleId: map['schedule_id'],
      listId: map['list_id'],
      marketDate: DateTime.parse(map['market_date']),
      notifyAt: map['notify_at'] != null ? DateTime.parse(map['notify_at']) : null,
    );
  }
}
