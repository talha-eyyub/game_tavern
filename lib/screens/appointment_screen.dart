import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import 'subscription_purchase_screen.dart';
import 'appointment_create_screen.dart';
import 'appointment_detail_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final UserManager _userManager = UserManager();

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

  @override
  Widget build(BuildContext context) {
    final user = _userManager.activeUser;
    final subscription = user?.subscription;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width*0.86,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text('Üye ID: ${user?.id ?? "-"}', style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 8),
            Text(
              'Abonelik Türü: ${subscription != null ? getLocalizedSubscriptionName(subscription!.type) : "Yok"}',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text('Kalan Seans: ${subscription?.remainingSessions ?? 0}', style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: subscription == null
                  ? () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionPurchaseScreen()),
                );
                setState(() {});
              }
                  : null,
              child: const Text('Abonelik Satın Al'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: subscription != null
                  ? () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppointmentCreateScreen()),
                );
                setState(() {});
              }
                  : null,
              child: const Text('Randevu Oluştur'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: subscription != null
                  ? () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppointmentDetailScreen()),
                );
                setState(() {});
              }
                  : null,
              child: const Text('Oluşturulan Randevular'),
            ),
          ],
        ),
      ),
    );
  }
}
