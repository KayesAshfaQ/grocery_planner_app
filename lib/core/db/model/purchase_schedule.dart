class PurchaseSchedule {
  final int? scheduleId;
  final int listId;
  final DateTime marketDate;
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
