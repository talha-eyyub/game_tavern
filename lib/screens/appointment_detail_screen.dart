import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import '../models/rendezvous.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final UserManager _userManager = UserManager();

  void _cancelAppointment(Rendezvous rendezvous) async {
    final user = _userManager.activeUser;
    if (user == null) return;

    user.schedule.removeSession(rendezvous);

    if (user.subscription != null) {
      user.subscription!.remainingSessions += 1;
    }

    await _userManager.saveUsers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Randevu iptal edildi!')),
    );

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final user = _userManager.activeUser;
    final sessions = (user?.schedule.sessions ?? [])..sort((a, b) {
      final aDate = DateTime(a.dateTime.year, a.dateTime.month, a.dateTime.day, a.hour);
      final bDate = DateTime(b.dateTime.year, b.dateTime.month, b.dateTime.day, b.hour);
      return aDate.compareTo(bDate);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oluşturulan Randevular'),
      ),
      body: sessions.isEmpty
          ? const Center(
        child: Text('Henüz randevu oluşturulmadı.', style: TextStyle(fontSize: 14)),
      )
          : ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final rendezvous = sessions[index];
          return Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                '${rendezvous.gameName}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              subtitle: Text(
                '${rendezvous.dateTime.day}/${rendezvous.dateTime.month}/${rendezvous.dateTime.year}  '
                    '${rendezvous.hour}:00 - ${rendezvous.hour + 2}:00',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              trailing: ElevatedButton(
                onPressed: () => _cancelAppointment(rendezvous),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('İptal Et'),
              ),
            ),
          );
        },
      ),
    );
  }
}
