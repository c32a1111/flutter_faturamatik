import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_faturamatik/flutter_faturamatik_method_channel.dart';
import 'package:flutter_faturamatik/modules/auto_selfie.dart';
import 'package:flutter_faturamatik/modules/nfc_capture_ios.dart';
import 'package:flutter_faturamatik/modules/id_capture.dart';
import 'package:flutter_faturamatik/modules/pose_estimation.dart';
import 'flutter_faturamatik_platform_interface.dart';

class FlutterFaturamatik {
final MethodChannelFlutterFaturamatik _methodChannel = MethodChannelFlutterFaturamatik();
  final delegateEventChannel = const EventChannel("faturamatiksdk_delegate_channel");

  /// returns [IdCapture] module
  IdCapture getIDCapture() {
    return IdCapture(_methodChannel);
  }

    /// Returns [PoseEstimation] module
  PoseEstimation getPoseEstimation() {
    return PoseEstimation(_methodChannel);
  }

  /// returns [AutoSelfie] module
  AutoSelfie getAutoSelfie() {
    return AutoSelfie(_methodChannel);
  }

   /// Returns [IOSNFCCapture] module
  IOSNFCCapture getIOSNFCCapture() {
    return IOSNFCCapture(_methodChannel);
  }

 Future<bool> setDelegates() async {
   
    try {
      var delegates = await _methodChannel.setDelegates(
      
      );
      return delegates;
    } catch (err) {
      rethrow;
    }
  }

 

  Stream<dynamic> getDelegateStream() {
    return delegateEventChannel.receiveBroadcastStream().map((event) => event);
  }


  
}
