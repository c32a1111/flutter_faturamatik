import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_faturamatik/common/models/nvi_data.dart';
import 'package:flutter_faturamatik/flutter_faturamatik_method_channel.dart';

enum IdSide { front, back }

class IdCapture {
  final MethodChannelFlutterFaturamatik _methodChannel;

  IdCapture(this._methodChannel);

  Future<Uint8List> start(IdSide idSide) async {
    try {
      final dynamic imageData =
          await _methodChannel.startIDCapture(idSide.index);
      if (imageData != null) {
        return imageData as Uint8List;
      } else {
        throw Exception("[FaturamatikSDK] no image returned from idCapture module");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> upload() async {
    try {
      final Map<dynamic, dynamic> response = await _methodChannel.uploadIDCapture();

      return {
        "status": response['status'] == true,
        "message": response['message'] ?? '',
      };
    } catch (err) {
      rethrow;
    }
  }
 
 

 Future<bool> iosStartNFC(Map<String, dynamic> mrzResult) async {
  
   

    if (!Platform.isIOS) return false;
    if (mrzResult.isEmpty != true) {
    
      print("DART IDCAPTURE TARAFINDA MRZRESULT DEGERI $mrzResult");
     try {
      final bool isDone = await _methodChannel.iOSStartIDCaptureNFC(mrzResult);
      return isDone;
       } catch (err) {
      rethrow;
       }
      } else {
        return false;
      }
  }

   Future<Map<String, dynamic>> processNFC(String mrzResult) async {
        Map<String, dynamic> mrzData = {};
        try {
          // Parse the incoming string data using the helper function
          final eventData = _parseMrzData(mrzResult);
          mrzData.addAll(eventData);
          return mrzData;
        } catch (e) {
          print("Hata: Veriyi ayrıştırma sırasında bir hata oluştu - $e");
          return {};
        }
  }

  Future<String?> getMrzRequest() async {
  if (!Platform.isIOS) return null;
  try {
    final result =  await _methodChannel.getMrzRequest();
    return result;
  } catch (err) {
    rethrow;
  }
}
  

  Future<void> setType(String type) async {
    await _methodChannel.setIDCaptureType(type);
  }

  Future<void> setManualButtonTimeout(int time) async {
    await _methodChannel.setIDCaptureManualButtonTimeout(time);
  }


  Future<void> setHologramDetection(bool enabled) async {
    return await _methodChannel.setIDCaptureHologramDetection(enabled);
  }


Map<String, dynamic> _parseMrzData(String data) {
  Map<String, dynamic> parsedData = {};

  // Regex to match both Optional and non-Optional values
  RegExp regex = RegExp(r'(\w+):\s*(Optional\("?(.*?)"?\)|"(.*?)"|(\S+))');
  Iterable<RegExpMatch> matches = regex.allMatches(data);

  for (var match in matches) {
    String key = match.group(1)!;
    String value = match.group(3) ?? match.group(4) ?? match.group(5) ?? '';

    // Add value to parsedData regardless of Optional
    parsedData[key] = value.isNotEmpty && value != 'nil' ? value : null;
  }

  return parsedData;
}
 
}
