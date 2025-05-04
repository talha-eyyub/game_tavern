import 'package:flutter/material.dart';
import '../managers/user_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserManager _userManager = UserManager();

  void _register() async {
    bool success = await _userManager.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarılı! Giriş ekranına yönlendiriliyorsunuz.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu e-posta ile zaten bir kullanıcı var.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 180),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize:13),
                  decoration: const InputDecoration(labelText: 'İsim'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize:13),
                  decoration: const InputDecoration(labelText: 'E-posta'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white, fontSize:13),
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
