import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faturamatik_example/screens/auto_selfie.dart';
import 'package:flutter_faturamatik_example/screens/confim.dart';
import 'package:flutter_faturamatik_example/screens/home.dart';
import 'package:flutter_faturamatik_example/screens/id_capture.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (ctx) => const HomeScreen(),
      '/id-capture': (ctx) => const IdCaptureScreen(),
      '/confirm': (ctx) => ConfirmScreen(),
      '/auto-selfie': (ctx) => const AutoSelfieScreen(),
    },
  ));
}
