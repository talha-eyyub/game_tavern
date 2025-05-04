import 'package:flutter/material.dart';
import 'managers/user_manager.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserManager _userManager = UserManager();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    await _userManager.loadUsers();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tavern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF3B0E0E),

        textTheme: GoogleFonts.pressStart2pTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF471828),
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(fontSize: 10),
          ),
          unselectedLabelStyle: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(fontSize: 9),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all(
              GoogleFonts.pressStart2p(
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
      home: _isLoading
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : _userManager.activeUser == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}
