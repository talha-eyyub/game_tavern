
import 'package:flutter/material.dart';
import '../screens/account_screen.dart';
import '../screens/machine_screen.dart';
import '../screens/login_screen.dart';
import '../managers/user_manager.dart';

class SharedDrawer extends StatelessWidget {
  const SharedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF3B0E0E),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF471828)),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/menu.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          ListTile(
            title: const Text('Hesabım'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Makineler'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MachineScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Oturumu Sonlandır', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              final userManager = UserManager();
              userManager.signOut();
              await userManager.saveUsers();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
