import 'package:flutter/material.dart';
import '../models/machine.dart';
import 'machine_info_screen.dart';
import '../managers/machine_manager.dart';
import 'dart:async';
class MachineScreen extends StatefulWidget {
  const MachineScreen({Key? key}) : super(key: key);

  @override
  State<MachineScreen> createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> {
  final machineManager = MachineManager();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Machine> machines = machineManager.machines;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makineler'),
      ),
      body: ListView.builder(
        itemCount: machines.length,
        itemBuilder: (context, index) {
          final machine = machines[index];
          return Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                machine.name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(
                machine.isActive ? 'Kullanımda' : 'Hazır',
                style: TextStyle(
                  color: machine.isActive ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MachineInfoScreen(machine: machine),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
