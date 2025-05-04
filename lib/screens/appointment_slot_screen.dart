import 'package:flutter/material.dart';
import '../managers/user_manager.dart';
import '../models/rendezvous.dart';

class AppointmentSlotScreen extends StatefulWidget {
  final String gameName;

  const AppointmentSlotScreen({Key? key, required this.gameName}) : super(key: key);

  @override
  State<AppointmentSlotScreen> createState() => _AppointmentSlotScreenState();
}

class _AppointmentSlotScreenState extends State<AppointmentSlotScreen> {
  final UserManager _userManager = UserManager();
  DateTime? _selectedDate;
  int? _selectedSlot;

  final List<int> slots = [10, 12, 14, 16, 18];

  bool isSlotBooked(int hour) {
    final user = _userManager.activeUser;
    if (user == null || _selectedDate == null) return false;
    final now = DateTime.now();
    final selectedDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, hour);
    if (selectedDateTime.isBefore(now)) return true;
    return user.schedule.sessions.any((rendezvous) =>
    rendezvous.dateTime.year == _selectedDate!.year &&
        rendezvous.dateTime.month == _selectedDate!.month &&
        rendezvous.dateTime.day == _selectedDate!.day &&
        rendezvous.hour == hour &&
        rendezvous.gameName == widget.gameName);
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null;
      });
    }
  }

  void _confirmBooking() async {
    final user = _userManager.activeUser;
    if (user == null || _selectedDate == null || _selectedSlot == null) return;

    if (user.subscription == null || user.subscription!.remainingSessions <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yetersiz seans hakkı!')),
      );
      return;
    }

    final newRendezvous = Rendezvous(
      dateTime: _selectedDate!,
      hour: _selectedSlot!,
      gameName: widget.gameName,
    );

    user.schedule.addSession(newRendezvous);

    user.subscription!.remainingSessions -= 1;

    if (user.subscription!.remainingSessions <= 0) {
      user.subscription = null;
    }

    await _userManager.saveUsers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Randevu başarıyla oluşturuldu!')),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameName} Randevu'),
      ),
      body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _selectDate,
              child: const Text('Gün Seç'),
            ),
            const SizedBox(height: 16),
            if (_selectedDate != null)
              Text(
                'Seçilen Gün: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),
            if (_selectedDate != null)
              Expanded(
                child: ListView.builder(
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final hour = slots[index];
                    final booked = isSlotBooked(hour);
                    final isSelected = _selectedSlot == hour;

                    Color color;
                    if (booked) {
                      color = Colors.red;
                    } else if (isSelected) {
                      color = Colors.yellow;
                    } else {
                      color = Colors.green;
                    }

                    return GestureDetector(
                      onTap: booked
                          ? null
                          : () {
                        setState(() {
                          _selectedSlot = hour;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$hour:00 - ${hour + 2}:00',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (_selectedDate != null && _selectedSlot != null) ? _confirmBooking : null,
              child: const Text('Onayla'),
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
