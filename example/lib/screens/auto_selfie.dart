import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter_faturamatik/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_faturamatik/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_faturamatik_example/screens/confim.dart';

class AutoSelfieScreen extends StatefulWidget {
  const AutoSelfieScreen({Key? key}) : super(key: key);

  @override
  State<AutoSelfieScreen> createState() => _AutoSelfieScreenState();
}

class _AutoSelfieScreenState extends State<AutoSelfieScreen> {
  final _autoSelfie = FlutterFaturamatik().getAutoSelfie();

  static const routeName = "/auto-selfie";

  Future<void> initSDK() async {
    await _autoSelfie.setType("XXX_SE_0");
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  Future<bool> onWillPop() async {
   
      return true;
    
  }

  // Configure the AutoSelfie
  final IOSAutoSelfieSettings _iOSAutoSelfieSettings = IOSAutoSelfieSettings(
      faceIsOk: "Please hold stable",
      notInArea: "Please align your face with the area",
      faceTooSmall: "Your face is in too far",
      faceTooBig: "Your face is in too close",
      completed: "All OK!",
      appBackgroundColor: "000000",
      appFontColor: "ffffff",
      primaryButtonBackgroundColor: "ffffff",
      ovalBorderSuccessColor: "00ff00",
      ovalBorderColor: "ffffff",
      countTimer: "3",
      manualCropTimeout: 30);

  final AndroidAutoSelfieSettings _androidAutoSelfieSettings =
      AndroidAutoSelfieSettings(
          textSize: 16,
          counterVisible: true,
          counterTextSize: 21,
          manualCropTimeout: 30,
          distanceText: "Please align your face with the area",
          faceNotFoundText: "No faces found",
          restartText: "Process failed, restarting...",
          stableText: "Please hold stable");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Start Autoselfie"),
        ),
        body: Center(
          child: OutlinedButton(
            onPressed: () {
              _autoSelfie
                  .start(
                      androidAutoSelfieSettings: _androidAutoSelfieSettings,
                      iosAutoSelfieSettings: _iOSAutoSelfieSettings)
                  .then((imageData) {
                Navigator.pushNamed(context, ConfirmScreen.routeName,
                    arguments: ConfirmArguments(
                        source: "autoSelfie", imageData: imageData));
              }).catchError((err) {
                throw Exception(err);
              });
            },
            child: const Text('Start Selfie'),
          ),
        ),
      ),
    );
  }
}
