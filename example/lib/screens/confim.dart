import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter_faturamatik/modules/id_capture.dart';

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen({Key? key}) : super(key: key);
  // Modules.
  final _idCapture = FlutterFaturamatik().getIDCapture();
  final _autoSelfie = FlutterFaturamatik().getAutoSelfie();


  static const routeName = '/confirm';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ConfirmArguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Confirm Document?"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(
            args.imageData,
            fit: BoxFit.contain,
            width: double.infinity,
            height: 450,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() => Navigator.pop(context)),
                  child: const Text("Try again!")),
              OutlinedButton(
                  onPressed: (() {
                    if (args.source == "idCapture" &&
                        args.idCaptureBothSidesTaken == true &&
                        args.idCaptureNFCCompleted == false) {
                      _idCapture.upload().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      });
                    } else if (args.source == "idCapture" &&
                        args.idCaptureBothSidesTaken == false) {
                      _idCapture.start(IdSide.back).then((imageData) {
                        Navigator.pushNamed(context, ConfirmScreen.routeName,
                                arguments: ConfirmArguments(
                                    source: "idCapture",
                                    imageData: imageData,
                                    idCaptureBothSidesTaken: true,
                                    idCaptureNFCCompleted: false))
                            .then((_) {
                          if (Platform.isIOS) {
                            // _idCapture.iosStartNFC().then((value) => null);
                          }
                        });
                      });
                    
                    } else if (args.source == "autoSelfie") {
                      _autoSelfie.upload().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      });
                    } 
                  }),
                  child: const Text("Confirm"))
            ],
          )
        ],
      ),
    );
  }
}

class ConfirmArguments {
  final String source;
  final Uint8List imageData;
  final bool? idCaptureBothSidesTaken;
  final bool? idCaptureNFCCompleted;
  ConfirmArguments(
      {required this.source,
      required this.imageData,
      this.idCaptureBothSidesTaken,
      this.idCaptureNFCCompleted});
}
