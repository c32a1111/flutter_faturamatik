import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter_faturamatik/modules/id_capture.dart';
import 'package:flutter/services.dart';
import 'package:flutter_faturamatik/common/models/nvi_data.dart';
import 'package:flutter_faturamatik_example/screens/confim.dart';
import 'package:flutter_faturamatik/flutter_faturamatik_method_channel.dart';




// class IdCaptureScreen extends StatefulWidget {
//   const IdCaptureScreen({Key? key}) : super(key: key);

//   @override
//   State<IdCaptureScreen> createState() => _IdCaptureScreenState();
// }

// class _IdCaptureScreenState extends State<IdCaptureScreen> {
//   final IdCapture _idCaptureModule = FlutterFaturamatik().getIDCapture();

//   Future<void> initSDK() async {
//     await _idCaptureModule.setType("TUR_ID_1");
//     await _idCaptureModule.setHologramDetection(false);
//   }

//   @override
//   void initState() {
//     super.initState();
//     initSDK();
//   }

//   Future<bool> onWillPop() async {
   
//       return true;
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.purple,
//           title: const Text('ID Capture Screen'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               OutlinedButton(
//                   onPressed: () {
//                     _idCaptureModule.start(IdSide.front).then((imageData) {
//                       Navigator.pushNamed(context, ConfirmScreen.routeName,
//                           arguments: ConfirmArguments(
//                               source: "idCapture",
//                               imageData: imageData,
//                               idCaptureBothSidesTaken: false,
//                               idCaptureNFCCompleted: false));
//                     }).catchError((err) {});
//                   },
//                   child: const Text("Start")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




class IdCaptureScreen extends StatefulWidget {
  const IdCaptureScreen({Key? key}) : super(key: key);

  @override
  State<IdCaptureScreen> createState() => _IdCaptureScreenState();
}

class _IdCaptureScreenState extends State<IdCaptureScreen> {
  final IdCapture _idCaptureModule = FlutterFaturamatik().getIDCapture();

  Future<void> initSDK() async {
    await _idCaptureModule.setType("TUR_ID_1");
    await _idCaptureModule.setHologramDetection(true);

  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  Future<bool> onWillPop() async {
   
      return true;
    }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text('ID Capture Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    _idCaptureModule.start(IdSide.front).then((imageData) {
                      Navigator.pushNamed(context, ConfirmScreenState.routeName,
                          arguments: ConfirmArguments(
                              source: "idCapture",
                              imageData: imageData,
                              idCaptureBothSidesTaken: false,
                              idCaptureNFCCompleted: false));
                    }).catchError((err) {});
                  },
                  child: const Text("Start")),
            ],
          ),
        ),
      ),
    );
  }


}
 
      
    