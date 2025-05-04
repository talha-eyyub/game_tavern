import 'package:flutter/material.dart';
import '../models/machine.dart';

class MachineInfoScreen extends StatelessWidget {
  final Machine machine;

  const MachineInfoScreen({Key? key, required this.machine}) : super(key: key);

  String _getDescription(String name) {
    switch (name) {
      case 'Hava Hokeyi':
        return 'Hava Hokeyi masasında rakibinizi yenmeye çalışın! 2 kişilik mücadele.';
      case 'Basket Atışı':
        return 'Basketbol atış makinesi ile zamana karşı en çok basketi atmaya çalışın.';
      case 'Pinball':
        return 'Klasik pinball makinelerinde en yüksek skoru yapın!';
      default:
        return 'Bu oyun hakkında henüz detaylı bilgi bulunmamaktadır.';
    }
  }

  String _getImageAssetName(String name) {
    if (name.contains('Hokeyi')) return 'assets/machines/machine_hockey.png';
    if (name.contains('Basket')) return 'assets/machines/machine_basket.png';
    if (name.contains('Pinball')) return 'assets/machines/machine_pinball.png';
    return 'assets/machines/default_machine.png';
  }

  @override
  Widget build(BuildContext context) {
    final description = _getDescription(machine.name);
    final imagePath = _getImageAssetName(machine.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(machine.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Text('Görsel yüklenemedi', style: TextStyle(color: Colors.white))),
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
