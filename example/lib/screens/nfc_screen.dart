import 'package:flutter/material.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({Key? key}) : super(key: key);

  @override
  State<NfcScreen> createState() => _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  bool _isNfcAvailable = false;
  bool _isReading = false;
  String _nfcData = "";

  @override
  void initState() {
    super.initState();
    // NFC kullanılabilir mi kontrolü burada yapılabilir
    checkNfcAvailability();
  }

  void checkNfcAvailability() async {
    // Bu örnekte sadece simülasyon, gerçek kontrol için platform-specific kod gerekir
    setState(() {
      _isNfcAvailable = true;
    });
  }

  void startNfcReading() async {
    setState(() {
      _isReading = true;
      _nfcData = "Reading NFC...";
    });

    await Future.delayed(const Duration(seconds: 2)); // Simülasyon

    setState(() {
      _nfcData = "Sample NFC Data: ABC123456789";
      _isReading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Screen"),
      ),
      body: Center(
        child: _isNfcAvailable
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_nfcData),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isReading ? null : startNfcReading,
                    child: Text(_isReading ? "Reading..." : "Start NFC"),
                  ),
                ],
              )
            : const Text("NFC not available on this device."),
      ),
    );
  }
}