import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';

import 'package:flutter_faturamatik/common/models/ios/pose_estimation_settings.dart';
import 'package:flutter_faturamatik_example/screens/confim.dart';

class PoseEstimationScreen extends StatefulWidget {
  const PoseEstimationScreen({Key? key}) : super(key: key);

  @override
  State<PoseEstimationScreen> createState() => _PoseEstimationScreenState();
}

class _PoseEstimationScreenState extends State<PoseEstimationScreen> {
  final _faturamatikPoseEstimation = FlutterFaturamatik().getPoseEstimation();

  static const routeName = "/pose-estimation";

  Future<void> initSDK() async {
    await _faturamatikPoseEstimation.setType("XXX_SE_0");
    // await _faturamatikPoseEstimation.setVideoRecording(true);
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  final IOSPoseEstimationSettings _iosPoseEstimationSettings =
      IOSPoseEstimationSettings(
    faceIsOk: "Please hold stable",
    notInArea: "Please align your face to the area",
    faceTooSmall: "Your face is in too far",
    faceTooBig: "Your face is in too close",
    completed: "Verification Completed",
    turnRight: "Kafanızı sağ tarafa ÇEVİRİN",
    turnLeft: "Kafanızı sol tarafa ÇEVİRİN",
    turnUp: "Kafanızı yukarı doğru KAlldırın",
    turnDown: "Kafanızı aşağı doğru İNDİRİM",
    lookStraight: "Look straight",
    errorMessage:
        "Please complete the steps while your face is aligned to the area",
    tryAgain: "Try again",
    errorTitle: "Verification Failure",
    confirm: "Confirm",
    next: "Next",
    holdPhoneVertically: "Please hold the phone straight",
    informationScreenDesc1:
        "To start verification, align your face with the area",
    informationScreenDesc2: "",
    informationScreenTitle: "Selfie Verification Instructions",
    wrongPose: "Your face must be straight",
    descriptionHeader:
        "Please make sure you are doing the correct pose and your face is aligned with the area",
    appBackgroundColor: "000000",
    appFontColor: "ffffff",
    primaryButtonBackgroundColor: "ffffff",
    primaryButtonTextColor: "000000",
    ovalBorderColor: "ffffff",
    ovalBorderSuccessColor: "00ff00",
    poseCount: "3",
    mainGuideVisibility: "true",
    secondaryGuideVisibility: "true",
    buttonRadious: "10",
    manualCropTimeout: 30,
  );

  Future<bool> onWillPop() async {
  
        return true;
      
  
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Pose estimation"),
        ),
        body: Center(
          child: OutlinedButton(
            onPressed: () {
              _faturamatikPoseEstimation
                  .start(
                      iosSettings: _iosPoseEstimationSettings)
                  .then((imageData) {
                Navigator.pushNamed(context, ConfirmScreenState.routeName,
                    arguments: ConfirmArguments(
                        source: "poseEstimation", imageData: imageData));
              }).catchError((err) {
                throw Exception(err);
              });
            },
            child: const Text('Start Pose Estimation'),
          ),
        ),
      ),
    );
  }
}
