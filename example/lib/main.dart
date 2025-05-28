import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faturamatik_example/screens/confim.dart';
import 'package:flutter_faturamatik_example/screens/home.dart';
import 'package:flutter_faturamatik_example/screens/id_capture.dart';
import 'package:flutter_faturamatik_example/screens/nfc_confirm.dart';
import 'package:flutter_faturamatik_example/screens/nfc_home.dart';
import 'package:flutter_faturamatik_example/screens/nfc_ios.dart';
import 'package:flutter_faturamatik_example/screens/pose_estimation.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (ctx) => const HomeScreen(),
      '/id-capture': (ctx) => const IdCaptureScreen(),
      '/confirm': (ctx) => ConfirmScreenState(),
      '/pose-estimation': (ctx) => const PoseEstimationScreen(),
      '/nfc': (ctx) => const NFCHome(),
      '/nfc-ios': (ctx) => const IOSNFC(),
      '/confirm-nfc': (ctx) => const NFCConfrimScreen(),
    },
  ));
}
