import 'package:flutter/material.dart';
import '../managers/user_manager.dart';

class BalanceTopupScreen extends StatefulWidget {
  const BalanceTopupScreen({Key? key}) : super(key: key);

  @override
  State<BalanceTopupScreen> createState() => _BalanceTopupScreenState();
}

class _BalanceTopupScreenState extends State<BalanceTopupScreen> {
  final UserManager _userManager = UserManager();
  int _amount = 0;
  bool _paymentSuccess = false;

  void _increaseAmount() {
    setState(() {
      _amount += 20;
    });
  }

  void _decreaseAmount() {
    setState(() {
      if (_amount >= 20) {
        _amount -= 20;
      }
    });
  }

  double _calculateBonus() {
    if (_amount >= 500) {
      return _amount * 0.2;
    } else if (_amount >= 350) {
      return _amount * 0.15;
    } else if (_amount >= 200) {
      return _amount * 0.1;
    } else {
      return 0;
    }
  }

  void _confirmPayment() async {
    final user = _userManager.activeUser;
    if (user == null) return;

    double bonus = _calculateBonus();
    double totalAmount = _amount + bonus;

    user.wallet.deposit(totalAmount);
    await _userManager.saveUsers();

    setState(() {
      _paymentSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _userManager.activeUser;

    if (_paymentSuccess) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text(
                'Ödenen tutar başarıyla bakiyenize aktarılmıştır.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakiye Yükle'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Üye ID: ${user?.id ?? "-"}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decreaseAmount,
                    icon: const Icon(Icons.remove_circle_outline, size: 40),
                  ),
                  Container(
                    width: 180,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_amount TL',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  IconButton(
                    onPressed: _increaseAmount,
                    icon: const Icon(Icons.add_circle_outline, size: 40),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_calculateBonus() > 0)
                Text(
                  'Eklenecek Bonus: +${_calculateBonus().toStringAsFixed(2)} TL',
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                ),
              const SizedBox(height: 24),
              const Text(
                'Bonuslar:\n'
                    '200-349 TL → %10 Bonus\n'
                    '350-499 TL → %15 Bonus\n'
                    '500 TL ve üzeri → %20 Bonus',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _amount > 0 ? _confirmPayment : null,
                child: const Text('Devam'),
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
