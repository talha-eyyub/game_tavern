class Slot {
  DateTime date;
  int hour;
  bool isBooked;

  Slot({
    required this.date,
    required this.hour,
    this.isBooked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'hour': hour,
      'isBooked': isBooked,
    };
  }

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      date: DateTime.parse(json['date']),
      hour: json['hour'],
      isBooked: json['isBooked'],
    );
  }
}
