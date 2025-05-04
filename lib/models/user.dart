import 'wallet.dart';
import 'schedule.dart';
import 'subscription.dart';

class User {
  final String id;
  final String name;
  final String email;
  String password;
  Wallet wallet;
  Schedule schedule;
  Subscription? subscription;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    Wallet? wallet,
    Schedule? schedule,
    this.subscription,
  })  : wallet = wallet ?? Wallet(),
        schedule = schedule ?? Schedule();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'wallet': wallet.toJson(),
      'schedule': schedule.toJson(),
      'subscription': subscription?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      wallet: Wallet.fromJson(json['wallet']),
      schedule: Schedule.fromJson(json['schedule']),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
    );
  }
}
