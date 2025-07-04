
import 'dart:typed_data';
import 'package:flutter_faturamatik/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_faturamatik/common/models/ios/auto_selfie_settings.dart';
import 'package:flutter_faturamatik/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_faturamatik/common/models/nvi_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_faturamatik_method_channel.dart';

abstract class FlutterFaturamatikPlatform extends PlatformInterface {
  /// Constructs a FlutterFaturamatikPlatform.
 FlutterFaturamatikPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFaturamatikPlatform _instance = MethodChannelFlutterFaturamatik();

  /// The default instance of [FlutterFaturamatikPlatform] to use.
  ///
  /// Defaults to [FlutterFaturamatikPlatform].
  static FlutterFaturamatikPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFaturamatikPlatform] when
  /// they register themselves.
  static set instance(FlutterFaturamatikPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  

  // IDCapture
  Future<dynamic> startIDCapture(int stepID) {
    throw UnimplementedError('startIDCapture() has not been implemented.');
  }

   Future<bool> iOSStartIDCaptureNFC(Map<String, dynamic> mrzResult) async {
    throw UnimplementedError(
        'iOSStartIDCaptureNFC() has not been implemented.');
  }

  Future<Map<String, dynamic>> uploadIDCapture() {
    throw UnimplementedError('uploadIDCapture() has not been implemented.');
  }

  Future<void> setIDCaptureManualButtonTimeout(int timeout) {
    throw UnimplementedError(
        'setIDCaptureManualButtonTimeout() has not been implemented.');
  }

  Future<void> setIDCaptureType(String type) {
    throw UnimplementedError('setIDCaptureType() has not been implemented.');
  }

  Future<void> setIDCaptureVideoRecording(bool enabled) {
    throw UnimplementedError(
        'setIDCaptureVideoRecording() has not been implemented.');
  }

  Future<void> setIDCaptureHologramDetection(bool enabled) {
    throw UnimplementedError(
        'setIDCaptureHologramDetection() has not been implemented.');
  }

  Future<bool> setDelegates() {
    throw UnimplementedError('setDelegates() has not been implemented.');
  }

  Future<void> setEnvironment(String type) {
    throw UnimplementedError('setDelegates() has not been implemented.');
  }

  // PoseEstimation
  Future<dynamic> startPoseEstimation(
      {required IOSPoseEstimationSettings iosPoseEstimationSettings}) {
    throw UnimplementedError('startPoseEstimation() has not been implemented.');
  }

  // Future<bool> uploadPoseEstimation() {
  //   throw UnimplementedError('uploadAutoSelfie() has not been implemented');
  // }
  Future<Map<String, dynamic>> uploadPoseEstimation() {
  throw UnimplementedError('uploadPoseEstimation() has not been implemented');
  }

  Future<void> setPoseEstimationType(String type) {
    throw UnimplementedError(
        'setPoseEstimationType() has not been implemented');
  }

  Future<void> setPoseEstimationVideoRecording(bool enabled) {
    throw UnimplementedError(
        'setPoseEstimationVideoRecording() has not been implemented');
  }

}
