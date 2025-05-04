import 'package:flutter/material.dart';

class GameInfoScreen extends StatelessWidget {
  final String gameName;

  const GameInfoScreen({Key? key, required this.gameName}) : super(key: key);

  String _getDescription(String game) {
    switch (game) {
      case 'PlayStation':
        return 'PlayStation salonunda en güncel oyunları deneyimleyin!';
      case 'VR':
        return 'VR dünyasında eşsiz bir sanal gerçeklik macerası sizi bekliyor!';
      case 'LaserTag':
        return 'LaserTag arenasında arkadaşlarınızla kıyasıya rekabet edin!';
      case 'Karaoke':
        return 'Karaoke salonunda favori şarkılarınızı söyleyin!';
      case 'Bowling':
        return 'Bowling pistinde arkadaşlarınızla yarışın!';
      default:
        return 'Oyun hakkında detaylı bilgi bulunamadı.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final description = _getDescription(gameName);

    return Scaffold(
      appBar: AppBar(
        title: Text('$gameName Bilgisi'),
      ),
    body: SafeArea(
    child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset(
              'assets/games/$gameName.png',
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.white24),
            ),
            const SizedBox(height: 24),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Geri Dön'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
