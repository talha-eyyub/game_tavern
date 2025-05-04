class Rendezvous {
  DateTime dateTime;
  int hour;
  String gameName;

  Rendezvous({
    required this.dateTime,
    required this.hour,
    required this.gameName,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'hour': hour,
      'gameName': gameName,
    };
  }

  factory Rendezvous.fromJson(Map<String, dynamic> json) {
    return Rendezvous(
      dateTime: DateTime.parse(json['dateTime']),
      hour: json['hour'],
      gameName: json['gameName'],
    );
  }
}
