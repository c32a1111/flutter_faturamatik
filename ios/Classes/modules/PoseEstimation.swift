//
//  PoseEstimation.swift
//  faturamatik_flutter
//
//  Created by Bedri Doğan on 25.03.2025.
//



import Flutter
import UIKit
import FaturamatikVerify

class PoseEstimation {
  private let module = Faturamatik.sharedInstance.poseEstimation()
  private var sdkView: SDKView!

  public func start(settings: PoseEstimationSettings, result: @escaping FlutterResult) {
    let vc = UIApplication.shared.windows.last?.rootViewController
    module.setScreenConfig(screenConfig: [
      .appBackgroundColor: settings.appBackgroundColor,
      .appFontColor: settings.appFontColor,
      .primaryButtonBackgroundColor: settings.primaryButtonBackgroundColor,
      .primaryButtonTextColor: settings.primaryButtonTextColor,
      .ovalBorderColor: settings.ovalBorderColor,
      .ovalBorderSuccessColor: settings.ovalBorderSuccessColor,
      .poseCount: settings.poseCount,
      .mainGuideVisibility: settings.mainGuideVisibility,
      .secondaryGuideVisibility: settings.secondaryGuideVisibility,
    ])

    module.setInfoMessages(infoMessages: [
      .faceIsOk: settings.faceIsOk,
      .notInArea: settings.notInArea,
      .faceTooSmall: settings.faceTooSmall,
      .faceTooBig: settings.faceTooBig,
      .completed: settings.completed,
      .turnRight: settings.turnRight,
      .turnLeft: settings.turnLeft,
      .turnUp: settings.turnUp,
      .turnDown: settings.turnDown,
      .lookStraight: settings.lookStraight,
      .errorMessage: settings.errorMessage,
      .next: settings.next,
      .tryAgain: settings.tryAgain,
      .errorTitle: settings.errorTitle,
      .holdPhoneVertically: settings.holdPhoneVertically,
      .informationScreenDesc1: settings.informationScreenDesc1,
      .informationScreenDesc2: settings.informationScreenDesc2,
      .informationScreenTitle: settings.informationScreenTitle,
      .wrongPose: settings.wrongPose,
      .descriptionHeader: settings.descriptionHeader,
    ])

    if
    let mainGuideUp = settings.mainGuideUp,
    let mainGuideDown = settings.mainGuideDown,
    let mainGuideLeft = settings.mainGuideLeft,
    let mainGuideRight = settings.mainGuideRight,
    let mainGuideStraight = settings.mainGuideStraight {
      module.setMainGuideImages(guideImages: [
        .mainGuideUp: UIImage(named: mainGuideUp)!,
        .mainGuideDown: UIImage(named: mainGuideDown)!,
        .mainGuideLeft: UIImage(named: mainGuideLeft)!,
        .mainGuideRight: UIImage(named: mainGuideRight)!,
        .mainGuideStraight: UIImage(named: mainGuideStraight)!,
      ])
    }
    
    if
    let secondaryGuideUp = settings.secondaryGuideUp,
    let secondaryGuideDown = settings.secondaryGuideDown,
    let secondaryGuideLeft = settings.secondaryGuideLeft,
    let secondaryGuideRight = settings.secondaryGuideRight
    {
      module.setSecondaryGuideImages(guideImages: [
        .secondaryGuideUp: UIImage(named: secondaryGuideUp)!,
        .secondaryGuideDown: UIImage(named: secondaryGuideDown)!,
        .secondaryGuideLeft: UIImage(named: secondaryGuideLeft)!,
        .secondaryGuideRight: UIImage(named: secondaryGuideRight)!,
      ])
    }

    module.setManualCropTimeout(Timeout: settings.manualCropTimeout)

    do {
      let moduleView = try module.start { image in
        let data = image.pngData()
        result(FlutterStandardTypedData(bytes: data!))
        
        DispatchQueue.main.async {
          self.sdkView.removeFromSuperview()
        }
      }
      
      sdkView = SDKView(sdkView: moduleView!)
      sdkView.start(on: vc!)
      sdkView.setupBackButton(on: moduleView!)
    } catch let err {
      result(FlutterError(code: "30007", message: err.localizedDescription, details: nil))
    }
  }

  public func setType(type: String, result: @escaping FlutterResult) {
    module.setType(type: type)
    result(nil)
  }

  public func upload(result: @escaping FlutterResult) {
     module.upload { isSuccess, extra in
      let resultDict: [String: Any?] = [
        "status": isSuccess,
        "message": extra
      ]
      debugPrint("pose est upload func result: \(resultDict)")
    result(resultDict)
    }
  }
  
  public func setVideoRecording(enabled: Bool, result: @escaping FlutterResult) {
    module.setVideoRecording(enabled: enabled)
    result(nil)
  }
}
