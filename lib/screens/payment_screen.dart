import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import '../managers/machine_manager.dart';
import '../models/machine.dart';
import 'balance_topup_screen.dart';
import 'qr_scan_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final UserManager _userManager = UserManager();
  final MachineManager _machineManager = MachineManager();
  Machine? _selectedMachine;

  Future<void> _activateSelectedMachine() async {
    if (_selectedMachine == null) return;

    try {
      await _machineManager.activateMachine(_selectedMachine!, () {
        setState(() {});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yetersiz bakiye!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _userManager.activeUser;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width*0.86,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'Bakiye: ${user?.wallet.balance.toStringAsFixed(2) ?? "0.00"} TL',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BalanceTopupScreen()),
                );
                setState(() {});
              },
              child: const Text('Bakiye Yükle'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScanScreen(
                      machines: _machineManager.machines,
                      onMachineActivated: (machine) async {
                        _selectedMachine = machine;
                        await _activateSelectedMachine();
                      },
                    ),
                  ),
                );
                setState(() {});
              },
              child: const Text('QR ile Ödeme'),
            ),
          ],
        ),
      ),
    );
  }
}
