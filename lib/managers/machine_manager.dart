import '../models/machine.dart';
import '../managers/user_manager.dart';
import 'package:firebase_database/firebase_database.dart';
class MachineManager {
  static final MachineManager _instance = MachineManager._internal();

  factory MachineManager() {
    return _instance;
  }

  MachineManager._internal();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> activateMachineInFirebase(String machineId, int durationInSeconds) async {
    await _dbRef.child('machines/$machineId').set({
      'active': true,
      'duration': durationInSeconds,
      'startTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> deactivateMachineInFirebase(String machineId) async {
    await _dbRef.child('machines/$machineId').set({
      'active': false,
      'duration': 0,
      'startTime': 0,
    });
  }
  List<Machine> machines = [
    Machine(id: 'machine001', name: 'Hava Hokeyi', price: 10.0, durationInMinutes: 1),
    Machine(id: 'machine002', name: 'Basket Atışı', price: 8.0, durationInMinutes: 2),
    Machine(id: 'machine003', name: 'Pinball', price: 5.0, durationInMinutes: 4),
  ];

  Future<void> activateMachine(Machine machine, Function onStatusChanged) async {
    final user = UserManager().activeUser;
    if (user == null) throw Exception("Aktif kullanıcı bulunamadı.");

    if (user.wallet.balance >= machine.price) {
      user.wallet.spend(machine.price);

      machine.isActive = true;
      onStatusChanged();
      await activateMachineInFirebase(machine.id, machine.durationInMinutes * 60);
      Future.delayed(Duration(minutes: machine.durationInMinutes), () async {
        machine.isActive = false;
        await deactivateMachineInFirebase(machine.id);
        onStatusChanged();
      });
    } else {
      throw Exception("Yetersiz bakiye.");
    }
  }
}
