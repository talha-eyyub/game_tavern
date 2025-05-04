import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import 'register_screen.dart';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserManager _userManager = UserManager();

  @override
  void initState() {
    super.initState();
    _userManager.loadUsers();
  }

  void _login() async {
    bool success = await _userManager.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-posta veya şifre yanlış.')),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
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
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize:13),
                  decoration: const InputDecoration(
                    labelText: 'E-posta'),
                    /*: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),*/
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white, fontSize:13),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Şifre'),
                    /*labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),*/
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Giriş Yap'),
                    ),
                    ElevatedButton(
                      onPressed: _goToRegister,
                      child: const Text('Kayıt Ol'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
