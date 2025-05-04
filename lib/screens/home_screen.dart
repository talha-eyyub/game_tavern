import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import 'payment_screen.dart';
import 'appointment_screen.dart';
import 'shared_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserManager _userManager = UserManager();
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    _HomeContent(),
    PaymentScreen(),
    AppointmentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF941A38),
      drawer: const SharedDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Image.asset('assets/arcade_top.png', width: double.infinity, height: 160, fit: BoxFit.fitWidth),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF941A38),
                      Color(0xFF9B1B31),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      minHeight: double.infinity,
                    ),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ),
            ),
            Image.asset('assets/arcade_bottom.png', width: double.infinity, height: 215, fit: BoxFit.fitWidth),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF941A38),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Bakiye/QR'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Randevular'),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: const Color(0xFF941A38),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.62),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset('assets/logo.png', height: 70),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final user = UserManager().activeUser;
    final sessions = (user?.schedule.sessions ?? [])..sort((a, b) {
      final aDate = DateTime(a.dateTime.year, a.dateTime.month, a.dateTime.day, a.hour);
      final bDate = DateTime(b.dateTime.year, b.dateTime.month, b.dateTime.day, b.hour);
      return aDate.compareTo(bDate);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.86,
            height: constraints.maxHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.6),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Scrollbar(
              thickness: 4,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Üye No:\n${user?.id ?? "-"}',
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${user?.name ?? "-"}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(height: 8),
                    Text('Bakiye: ${user?.wallet.balance.toStringAsFixed(2)} TL',
                        style: const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(height: 16),
                    const Text('Oluşturulan Randevular:', style: TextStyle(color: Colors.white, fontSize: 15)),
                    if (sessions.isEmpty)
                      const Text('Hiç randevu bulunamadı.', style: TextStyle(color: Colors.white70, fontSize: 13))
                    else
                      for (var r in sessions)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '• ${r.gameName} — ${r.dateTime.day}/${r.dateTime.month}/${r.dateTime.year}\n${r.hour}:00 - ${r.hour + 2}:00',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

