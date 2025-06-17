import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_faturamatik/common/models/nvi_data.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter_faturamatik/modules/id_capture.dart';
import 'package:flutter_faturamatik_example/screens/nfc_confirm.dart';

class ConfirmScreenState extends StatefulWidget {
  const ConfirmScreenState({super.key});
  static const routeName = '/confirm';

  @override
  State<ConfirmScreenState> createState() => _ConfirmScreen();
}

class _ConfirmScreen extends State<ConfirmScreenState> {
  static const eventChannel = EventChannel('faturamatiksdk_delegate_channel');

  StreamSubscription<dynamic>? _eventSubscription;
  // Modules.
  final _idCapture = FlutterFaturamatik().getIDCapture();
  final _poseEstimation = FlutterFaturamatik().getPoseEstimation();

  String _error = "No Error";
  Map<String, dynamic> mrzResult = {};
  String? mrzDocId = "";
  int mrzReqCount = 0;
  bool _isLoading = false;
  
  

Future<String?> startMrzRequest() async {
  final String? mrzDocId = await _idCapture.getMrzRequest();
  return mrzDocId;
}

  @override 
  void initState() {
    super.initState();
      // MRZ listener başlatmayı frame sonrası çalıştır

    startListeningForMrzResult();
  

  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ConfirmArguments;

    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      title: const Text("Confirm Document?"),
    ),
    body: _isLoading
    ?Center(child: CircularProgressIndicator())
     :Column(
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
                onPressed: (() async {
                 setState(() {
                   _isLoading = true;
                 });
                  if (args.source == "idCapture" &&
                      args.idCaptureBothSidesTaken == true &&
                      args.idCaptureNFCCompleted == true) {
                    
                      final result = await _idCapture.upload();
            
                      final bool isSuccess = result['status'];
                      final String message = result['message'];
                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  } else if (args.source == "idCapture" &&
                      args.idCaptureBothSidesTaken == true &&
                      args.idCaptureNFCCompleted == false) {
                   if (Platform.isIOS) {
                      await startMrzRequest();
                      Map<String, dynamic> result = await startListeningForMrzResult();
                      debugPrint("listeningMRZInfoDelegate result: $result, and mrzResult: $mrzResult");
                      if (mrzResult.isNotEmpty) {
                        bool isDone = await _idCapture.iosStartNFC(result);
                        if (isDone) {
                     
                          final result = await _idCapture.upload();
                      
                          final bool isSuccess = result['status'];
                          final String message = result['message'];
                          if (isSuccess) {
                            Navigator.pushNamed(
                              context,
                              ConfirmScreenState.routeName,
                              arguments: ConfirmArguments(
                                source: "idCapture",
                                imageData: args.imageData,
                                idCaptureBothSidesTaken: true,
                                idCaptureNFCCompleted: true,
                              ),
                            );
                          }
                        }
                      } else {
                        print("MRZ veya NFC datası eksik.");
                      }
                    }
                  } else if (args.source == "idCapture" &&
                      args.idCaptureBothSidesTaken == false) {
                    var imageData = await _idCapture.start(IdSide.back);
                    Navigator.pushNamed(context, ConfirmScreenState.routeName,
                        arguments: ConfirmArguments(
                            source: "idCapture",
                            imageData: imageData,
                            idCaptureBothSidesTaken: true,
                            idCaptureNFCCompleted: false))
                        .then((_) async {
                      if (Platform.isIOS) {
                          
                          Map<String, dynamic> result = await startListeningForMrzResult();
                          debugPrint("listeningMRZInfoDelegate result: $result, and mrzResult: $mrzResult");
                          if (mrzResult.isNotEmpty) {
                            bool isDone = await _idCapture.iosStartNFC(result);
                            if (isDone) {
                        
                              final result = await _idCapture.upload();
                              print("confirm ekranı result değeriii $result");
                              final bool isSuccess = result['status'];
                              final String message = result['message'];
                              if (isSuccess) {
                                Navigator.pushNamed(
                                  context,
                                  ConfirmScreenState.routeName,
                                  arguments: ConfirmArguments(
                                    source: "idCapture",
                                    imageData: args.imageData,
                                    idCaptureBothSidesTaken: true,
                                    idCaptureNFCCompleted: true,
                                  ),
                                );
                              }
                            }
                          } else {
                            print("MRZ veya NFC datası eksik.");
                          }
                        }
                    });
                  } else if (args.source == "poseEstimation") {
                    final result = await _poseEstimation.upload();
                    print("confirm ekranı result değeriii $result");
                    final bool isSuccess = result['status'];
                    final String message = result['message'];

                    if (isSuccess) {
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      print("Upload failed: $message");
                    }
                    
                  }}),
                child: const Text("Confirm"))
          ],
        )
      ],
    ),
  );
  }

  Future<Map<String, dynamic>> _processAndStartNFC(String mrzString) async {
    Map<String, dynamic> mrzData = await _idCapture.processNFC(mrzString);
    mrzResult.addAll(mrzData);
    return mrzResult;
  }

 Future<Map<String, dynamic>> startListeningForMrzResult() async {
  final completer = Completer<Map<String, dynamic>>();

  _eventSubscription = eventChannel.receiveBroadcastStream().listen(
    (event) async {

      if (event['type'] == 'mrzInfoDelegate') {
        if (event['data'] is String) {
    
          try {
            setState(() {
              _isLoading = true;
            });

            Map<String, dynamic> processed = await _processAndStartNFC(event['data']);

            setState(() {
              _isLoading = false;
              mrzResult = processed;
            });

            print("CONFIRM EKRANI MRZ DATA WIDGET'A GONDERILICEK $mrzResult");

            if (!completer.isCompleted) {
              completer.complete(processed);
            }

          } catch (e) {
            print("Error while processing NFC: $e");
            setState(() {
              _error = "NFC işlem hatası";
              _isLoading = false;
            });

            if (!completer.isCompleted) {
              completer.complete({});
            }
          }
        }
      } else if (event['type'] == 'error') {
  
        setState(() {
          _error = "Hata: ${event['data']['error_message']}";
          _isLoading = false;
        });

        if (!completer.isCompleted) {
          completer.complete({});
        }
      }
    },
    onError: (error) {

      setState(() {
        _error = "Error: $error";
        _isLoading = false;
      });

      if (!completer.isCompleted) {
        completer.complete({});
      }
    },
  );

  return completer.future;
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
