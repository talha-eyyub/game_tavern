import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import '../models/subscription.dart';

class SubscriptionPurchaseScreen extends StatelessWidget {
  const SubscriptionPurchaseScreen({Key? key}) : super(key: key);

  final Map<String, Map<String, dynamic>> subscriptions = const {
    'daily': {'price': 100.0, 'sessions': 3, 'durationDays': 1},
    'monthly': {'price': 300.0, 'sessions': 15, 'durationDays': 30},
    'yearly': {'price': 1000.0, 'sessions': 180, 'durationDays': 365},
  };

  void _purchase(BuildContext context, String type) async {
    final userManager = UserManager();
    final user = userManager.activeUser;
    if (user == null) return;

    final price = subscriptions[type]!['price'] as double;
    final sessions = subscriptions[type]!['sessions'] as int;
    final durationDays = subscriptions[type]!['durationDays'] as int;

    if (user.wallet.balance >= price) {
      user.wallet.spend(price);

      user.subscription = Subscription(
        type: type,
        remainingSessions: sessions,
        expirationDate: DateTime.now().add(Duration(days: durationDays)),
      );

      await userManager.saveUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abonelik başarıyla satın alındı!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yetersiz bakiye! Lütfen bakiye yükleyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String getLocalizedSubscriptionName(String type) {
      switch (type) {
        case 'daily':
          return 'Günlük';
        case 'monthly':
          return 'Aylık';
        case 'yearly':
          return 'Yıllık';
        default:
          return type;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonelik Satın Al'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: subscriptions.keys.map((type) {
            final price = subscriptions[type]!['price'];
            final sessions = subscriptions[type]!['sessions'];
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  '${getLocalizedSubscriptionName(type)}\nAbonelik',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  '$price TL\n$sessions Seans',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _purchase(context, type),
                  child: const Text('Satın Al'),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
