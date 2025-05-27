import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_faturamatik/common/models/nvi_data.dart';
import 'package:flutter_faturamatik/flutter_faturamatik_method_channel.dart';

class IOSNFCCapture {
  final MethodChannelFlutterFaturamatik _methodChannel;

  IOSNFCCapture(this._methodChannel);

  Future<bool> startWithImageData(Uint8List imageData) async {
    try {
      final bool isSuccess =
          await _methodChannel.iOSNFCCaptureWithImageData(imageData);
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> startWithNviModel(NviModel nviModel) async {
  try {
    final result = await _methodChannel.iOSNFCCaptureWithNviData(nviModel);
    return result;
  } catch (err) {
    rethrow;
  }
}

  Future<bool> startWithMRZCapture() async {
    try {
      final bool isSuccess = await _methodChannel.iosNFCCaptureWithMRZCapture();
      return isSuccess;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> upload() async {
    try {
      final bool isDone = await _methodChannel.iosUploadNFCCapture();
      return isDone;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> setType(String type) async {
    await _methodChannel.iosSetNFCType(type);
  }
}
