import Flutter
import UIKit
import FaturamatikVerify

public class FlutterFaturamatikPlugin: NSObject, FlutterPlugin {
  var methodChannel: FlutterMethodChannel!
  var delegateChannel: FlutterEventChannel!
  static var eventHandler = DelegateEventHandler()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "faturamatiksdk_method_channel", binaryMessenger: registrar.messenger())
    let delegateChannel = FlutterEventChannel(name: "faturamatiksdk_delegate_channel", binaryMessenger: registrar.messenger())
    
    let instance = FlutterFaturamatikPlugin()
    instance.methodChannel = methodChannel
    instance.methodChannel = methodChannel
    instance.delegateChannel = delegateChannel
    instance.delegateChannel.setStreamHandler(FlutterFaturamatikPlugin.eventHandler)
    
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any]
    switch call.method {
    
    case "setDelegates":
    setDelegates()
    // ID Capture
    case "setIDCaptureType":
      let idCapture = IdCapture()
      let type = arguments?["type"] as! String
      idCapture.setType(type: type, result: result)
    case "startIDCapture":
      let idCapture = IdCapture()
      let stepID = arguments?["stepID"] as? Int
      idCapture.start(stepID: stepID ?? 0, result: result)
    case "setIDCaptureManualButtonTimeout":
      let idCapture = IdCapture()
      let timeout = arguments?["timeout"] as! Int
      idCapture.setManualCaptureButtonTimeout(timeout: timeout, result: result)
  
    case "iosIDCaptureNFC":
      if let arguments = call.arguments as? [String: Any], 
           let birthDate = arguments["birthDate"] as? String,
           let expireDate = arguments["expireDate"] as? String,
           let documentNo = arguments["documentNo"] as? String {
            
            
            let idCapture = IdCapture()
            Task {
                let nviModel = NviModel(documentNo: documentNo, dateOfBirth: birthDate, dateOfExpire: expireDate)
                let isDone = await idCapture.startNFC(nvi: nviModel)
                
                result(isDone)
            }
        } else {
            result(FlutterError(code: "30009", message: "Invalid arguments", details: nil))
        }

   case "setIDCaptureHologramDetection":
      let idCapture = IdCapture()
      let enabled = arguments?["enabled"] as? Bool
      // defaults to false as this feature only supported for TUR_ID
      idCapture.setHologramDetection(enabled: enabled ?? false, result: result)
    case "uploadIDCapture":
      let idCapture = IdCapture()
      idCapture.upload(result: result)

    case "getMrz":
     let idCapture = IdCapture()
     idCapture.getMrz(result: result)

    // Pose Estimation
    case "startPoseEstimation":
      let poseEstimation = PoseEstimation()
      let iosArgs = arguments?["iosSettings"] as! String
      let decoder = JSONDecoder()
      let poseEstimationSettings = try! decoder.decode(PoseEstimationSettings.self, from: Data(iosArgs.utf8))
      poseEstimation.start(settings: poseEstimationSettings, result: result)
    case "setPoseEstimationType":
        let poseEstimation = PoseEstimation()
        let type = arguments?["type"] as! String
        poseEstimation.setType(type: type, result: result)
    case "setPoseEstimationVideoRecording":
      let poseEstimation = PoseEstimation()
      let enabled = arguments?["enabled"] as? Bool
      poseEstimation.setVideoRecording(enabled: enabled ?? true, result: result)
    case "uploadPoseEstimation":
        let poseEstimation = PoseEstimation()
        poseEstimation.upload(result: result)
       // NFC
    // case "iOSstartNFCWithImageData":
    //     let nfc = NFC()
    //     let imageData = arguments?["imageData"] as! FlutterStandardTypedData
    //     nfc.start(imageData: imageData, result: result)
    case "iOSstartNFCWithNviModel":
        Task {
            do {
                let nfc = NFC()
                guard let nviData = arguments?["nviData"] as? [String: String] else {
                    result(FlutterError(code: "400", message: "Invalid arguments", details: nil))
                    return
                }
                let nviModel = NviModel(
                    documentNo: nviData["documentNo"]!,
                    dateOfBirth: nviData["dateOfBirth"]!,
                    dateOfExpire: nviData["dateOfExpire"]!
                )
                try await nfc.start(nviData: nviModel, result: result)
            } catch {
                result(FlutterError(code: "500", message: "Internal error", details: nil))
            }
        }
    case "iOSstartNFCWithMRZCapture":
     if #available(iOS 13, *) {
        Task {
            do {
                let nfc = NFC()
                 let nviData = arguments?["nviData"] as! [String: String]
                 let nviModel = NviModel(documentNo: nviData["documentNo"]!, dateOfBirth: nviData["dateOfBirth"]!, dateOfExpire: nviData["dateOfExpire"]!)
                try await nfc.start(nviData: nviModel, result: result)  
                
            } catch let err {
                result(FlutterError(code: "30007", message: err.localizedDescription, details: nil))
            }
        }
      } else {
        result(FlutterError(code: "30008", message: "NFC Requires iOS 13 or newer", details: nil))
      }
    case "iOSsetNFCType":
        let nfc = NFC()
        let type = arguments?["type"] as! String
        nfc.setType(type: type, result: result)
    case "iOSuploadNFC":
        let nfc = NFC()
        nfc.upload(result: result)
    case "setNFCInfoMessages":
        if let args = call.arguments as? [String: String] {
            let messageStruct = NFCInfoMessages(dict: args)
            let nfc = NFC()
            nfc.setNFCInfoMessages(messages: messageStruct, result: result)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected a map of string values", details: nil))
        }
    case "setEnvironment":
      let type = arguments?["type"] as! String
      setEnvironment(args: type)

    default:
      result(FlutterMethodNotImplemented)
    }


  }

  private func setDelegates() {
    Faturamatik.sharedInstance.setDelegate(delegate: FlutterFaturamatikPlugin.eventHandler)
    Faturamatik.sharedInstance.setMRZDelegate(delegate: FlutterFaturamatikPlugin.eventHandler)
   
  }

  private func setEnvironment(args: String?) {
    guard let envType = args else { return }
    Faturamatik.sharedInstance.setEnvironment(environment: envType)
  }

  
}
