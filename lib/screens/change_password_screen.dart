import 'package:flutter/material.dart';
import '../managers/user_manager.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hata', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Başarılı'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
  void _changePassword() async {
    final user = UserManager().activeUser;
    if (user == null) return;

    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final repeat = _repeatPasswordController.text;

    if (current != user.password) {
      _showErrorDialog('Mevcut parolanızı hatalı girdiniz.');
      return;
    }

    if (newPass != repeat) {
      _showErrorDialog('Yeni şifre ve tekrarı eşleşmiyor.');
      return;
    }
    user.password = newPass;
    await UserManager().saveUsers();

    _showSuccessDialog('Şifreniz başarıyla değiştirildi.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifre Değiştir')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mevcut Şifreniz'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Yeni Şifre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _repeatPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Yeni Şifre Tekrar'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Şifreyi Güncelle'),
            ),
          ],
        ),
      ),
    );
  }
}
