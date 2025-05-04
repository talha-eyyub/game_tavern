import 'package:flutter/material.dart';
import 'appointment_slot_screen.dart';
import 'game_info_screen.dart';

class AppointmentCreateScreen extends StatelessWidget {
  const AppointmentCreateScreen({Key? key}) : super(key: key);

  final List<String> games = const [
    'PlayStation',
    'VR',
    'LaserTag',
    'Karaoke',
    'Bowling',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  game,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentSlotScreen(gameName: game),
                          ),
                        );
                      },
                ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameInfoScreen(gameName: game),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
