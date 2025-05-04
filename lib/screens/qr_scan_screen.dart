import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../models/machine.dart';

class QrScanScreen extends StatefulWidget {
  final List<Machine> machines;
  final Function(Machine) onMachineActivated;

  const QrScanScreen({Key? key, required this.machines, required this.onMachineActivated}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _showCamera = true;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showCamera
          ? QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      final scannedId = scanData.code ?? "";
      final matchedMachine = widget.machines.firstWhere(
            (machine) => machine.id == scannedId,
        orElse: () => Machine(id: 'none', name: 'Bilinmeyen', price: 0, durationInMinutes: 0),
      );

      if (matchedMachine.id == 'none') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Makine bulunamadı.')),
        );
        controller.resumeCamera();
      } else if (matchedMachine.isActive) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Makine Kullanımda', style: TextStyle(color: Colors.white)),
            content: const Text('Bu makine kullanımda. Başka bir makine deneyin.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();
                },
                child: const Text('Tamam', style: TextStyle(color: Colors.cyanAccent)),
              ),
            ],
          ),
        );
      } else {
        widget.onMachineActivated(matchedMachine);
        setState(() {
          _showCamera = false;
        });

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Makine Başlatıldı!', style: TextStyle(color: Colors.white)),
            content: Text(
              '${matchedMachine.name} aktive edildi.\nİyi eğlenceler!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Tamam', style: TextStyle(color: Colors.cyanAccent)),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
