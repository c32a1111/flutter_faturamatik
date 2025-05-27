import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';

class NFCConfrimScreen extends StatefulWidget {
  const NFCConfrimScreen({super.key});
  static const routeName = '/confirm-nfc';

  @override
  State<NFCConfrimScreen> createState() => _NFCConfrimScreenState();
}

class _NFCConfrimScreenState extends State<NFCConfrimScreen> {
  bool _isCapturing = false;
  bool _uploadState = false;
  bool _errorState = false;
  bool _startState = false;
  bool _HasNfc = false;

  final _idCapture = FlutterFaturamatik().getIDCapture();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Capture NFC"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text("Is Capturing: $_isCapturing"),
                Text("Nfc Caputred: $_HasNfc"),
                Text("Upload State: $_uploadState"),
                Text("Error State: $_errorState"),
                Text("Started State: $_startState"),
              
              ],
            )
          ],
        ),
      ),
    );
  }
}