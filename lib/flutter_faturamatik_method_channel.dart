import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_faturamatik_platform_interface.dart';
import 'package:flutter_faturamatik/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_faturamatik/common/models/ios/auto_selfie_settings.dart';

/// An implementation of [FlutterFaturamatikPlatform] that uses method channels.
class MethodChannelFlutterFaturamatik extends FlutterFaturamatikPlatform {
// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('faturamatiksdk_method_channel');

  @override
  Future<dynamic> startIDCapture(int stepID) async {
    try {
      final dynamic imageData = await methodChannel
          .invokeMethod<dynamic>('startIDCapture', {"stepID": stepID});
      return imageData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> uploadIDCapture() async {
    try {
      final bool isDone = await methodChannel.invokeMethod('uploadIDCapture');
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setIDCaptureType(String type) async {
    try {
      await methodChannel.invokeMethod('setIDCaptureType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setIDCaptureHologramDetection(bool enabled) async {
    await methodChannel
        .invokeMethod("setIDCaptureHologramDetection", {"enabled": enabled});
  }

  @override
  Future<void> setIDCaptureManualButtonTimeout(int timeout) async {
    try {
      await methodChannel.invokeMethod(
          'setIDCaptureManualButtonTimeout', {"timeout": timeout});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> iOSStartIDCaptureNFC() async {
    try {
      final bool isDone = await methodChannel.invokeMethod('iosIDCaptureNFC');
      return isDone;
    } catch (err) {
      rethrow;
    }
  }


  // AutoSelfie
  @override
  Future<dynamic> startAutoSelfie(
      {required AndroidAutoSelfieSettings androidSettings,
      required IOSAutoSelfieSettings iosSettings}) async {
    final String androidSettingsJSON = jsonEncode(androidSettings);
    final String iosSettingsJSON = jsonEncode(iosSettings);
    try {
      final imgData = await methodChannel.invokeMethod('startAutoSelfie', {
        "iosSettings": iosSettingsJSON,
        "androidSettings": androidSettingsJSON
      });
      return imgData;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setAutoSelfieType({required String type}) async {
    try {
      await methodChannel.invokeMethod('setAutoSelfieType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> uploadAutoSelfie() async {
    try {
      final bool status = await methodChannel.invokeMethod('uploadAutoSelfie');
      return status;
    } catch (err) {
      rethrow;
    }
  }
}
