import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'common/models/nvi_data.dart';
import 'flutter_faturamatik_platform_interface.dart';
import 'package:flutter_faturamatik/common/models/android/auto_selfie_settings.dart';
import 'package:flutter_faturamatik/common/models/ios/auto_selfie_settings.dart';
import 'flutter_faturamatik_platform_interface.dart';
import 'package:flutter_faturamatik/common/models/ios/pose_estimation_settings.dart';

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
  Future<bool> iOSStartIDCaptureNFC(Map<String, dynamic> mrzResult) async {
    String _mrzDocumentNo = "";
    String _mrzDateOfBirth = "";
    String _mrzDateOfExpire = "";
    try {
       if (mrzResult.isNotEmpty) {
        mrzResult.forEach((key, value) {
          if (key == "mrzDocumentNumber") {
            _mrzDocumentNo = value;
          } else if (key == "mrzExpiryDate") {
            _mrzDateOfExpire = value;
          } else if (key == "mrzBirthDate") {
            _mrzDateOfBirth = value;
          }
        });
        
      }
      print("Sending arguments to iOS DateOfBirth: $_mrzDateOfBirth");
      final bool isDone = await methodChannel.invokeMethod('iosIDCaptureNFC', {
        "birthDate": _mrzDateOfBirth,
        "expireDate": _mrzDateOfExpire,
        "documentNo": _mrzDocumentNo
    });
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

// NFC Capture For IOS
  @override
  Future<bool> iosNFCCaptureWithMRZCapture() async {
    try {
      final bool isSuccess =
          await methodChannel.invokeMethod('iOSstartNFCWithMRZCapture');
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> iOSNFCCaptureWithImageData(Uint8List imageData) async {
    try {
      final bool isSuccess = await methodChannel
          .invokeMethod('iOSstartNFCWithImageData', {'imageData': imageData});
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  // @override
  // Future<bool> iOSNFCCaptureWithNviData(NviModel nviModel) async {
  //   try {
  //     final bool isSuccess = await methodChannel.invokeMethod(
  //         'iOSstartNFCWithNviModel', {'nviData': nviModel.toMap()});
  //     return isSuccess;
  //   } catch (err) {
  //     rethrow;
  //   }
  // }

@override
Future<Map<String, dynamic>> iOSNFCCaptureWithNviData(NviModel nviModel) async {
  try {
    final result = await methodChannel.invokeMethod(
        'iOSstartNFCWithNviModel', {'nviData': nviModel.toMap()});
    return Map<String, dynamic>.from(result);
  } catch (err) {
    rethrow;
  }
}

  @override
  Future<bool> iosUploadNFCCapture() async {
    try {
      final bool isSuccess = await methodChannel.invokeMethod('iOSuploadNFC');
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> iosSetNFCType(String type) async {
    try {
      await methodChannel.invokeMethod('iOSsetNFCType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
    Future<String?> getMrzRequest() async {
    try {

     final String? result = await methodChannel.invokeMethod<String>('getMrz');
      print("gelen result değeri: $result");
      if (result != null) {
        
        print("Gelen JSON verisi: $result");
      try {
        var resultMap = await json.decode(json.encode(result));
        print("Method Channel tarafında result map değeri return edildi:  $resultMap");
        return resultMap;
      } catch (e) {
        print("JSON decoding failed: $e");
        return null;
      }

    } else {
      print("Result nil geldi");
    }
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

  @override
  Future<bool> setDelegates() async {
    try {
      final bool isSetDelegate = await methodChannel.invokeMethod('setDelegates', {
      });
      return isSetDelegate;
    } catch (err) {
      rethrow;
    }
  }

  // Pose Estimation
  @override
  Future startPoseEstimation(
      {
      required IOSPoseEstimationSettings iosPoseEstimationSettings}) async {
   
    final String iosSettingsJSON = jsonEncode(iosPoseEstimationSettings);
    try {
      final dynamic imgData =
          await methodChannel.invokeMethod('startPoseEstimation', {
        "iosSettings": iosSettingsJSON,
      });
      return imgData;
    } catch (err) {
      rethrow;
    }
  }



  @override
  Future<bool> uploadPoseEstimation() async {
    try {
      final bool isDone =
          await methodChannel.invokeMethod('uploadPoseEstimation');
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setPoseEstimationType(String type) async {
    try {
      await methodChannel.invokeMethod('setPoseEstimationType', {"type": type});
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> setPoseEstimationVideoRecording(bool enabled) async {
    await methodChannel
        .invokeMethod("setPoseEstimationVideoRecording", {"enabled": enabled});
  }

}
