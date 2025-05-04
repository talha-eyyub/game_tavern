import 'rendezvous.dart';

class Schedule {
  List<Rendezvous> sessions;

  Schedule({List<Rendezvous>? sessions}) : sessions = sessions ?? [];

  void addSession(Rendezvous rendezvous) {
    sessions.add(rendezvous);
  }

  void removeSession(Rendezvous rendezvous) {
    sessions.remove(rendezvous);
  }

  Map<String, dynamic> toJson() {
    return {
      'sessions': sessions.map((r) => r.toJson()).toList(),
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    var sessionsFromJson = (json['sessions'] as List)
        .map((session) => Rendezvous.fromJson(session))
        .toList();

    return Schedule(sessions: sessionsFromJson);
  }
}
