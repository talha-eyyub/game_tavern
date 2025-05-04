import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import 'change_password_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserManager().activeUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hesabım')),
        body: const Center(child: Text('Kullanıcı bilgisi bulunamadı.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Hesabım')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hesap Bilgileri',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Üye ID:\n${user.id}'),
            const SizedBox(height: 16),
            Text('İsim:\n${user.name}'),
            const SizedBox(height: 16),
            Text('E-posta:\n${user.email}'),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                  );
                },
                child: const Text('Şifre Değiştir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
