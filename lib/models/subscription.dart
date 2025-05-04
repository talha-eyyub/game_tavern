class Subscription {
  String type;
  int remainingSessions;
  DateTime expirationDate;

  Subscription({
    required this.type,
    required this.remainingSessions,
    required this.expirationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'remainingSessions': remainingSessions,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      type: json['type'],
      remainingSessions: json['remainingSessions'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  bool isExpired() {
    return DateTime.now().isAfter(expirationDate);
  }
}
