import 'dart:typed_data';

import 'package:flutter_faturamatik/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_faturamatik/flutter_faturamatik_method_channel.dart';


class PoseEstimation {
  final MethodChannelFlutterFaturamatik _methodChannel;

  PoseEstimation(this._methodChannel);

  Future<Uint8List> start(
      {required IOSPoseEstimationSettings iosSettings,
      }) async {
    try {
      final dynamic imageData = await _methodChannel.startPoseEstimation(
          iosPoseEstimationSettings: iosSettings,);
      if (imageData != null) {
        return imageData as Uint8List;
      } else {
        throw Exception(
            "[FaturamatikSDK] no image returned from poseEstimation module");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.uploadPoseEstimation();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.setPoseEstimationType(type);
  }

  Future<void> setVideoRecording(bool enabled) async {
    await _methodChannel.setPoseEstimationVideoRecording(enabled);
  }
}
