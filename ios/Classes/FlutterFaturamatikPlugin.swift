import Flutter
import UIKit

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
  
   case "setIDCaptureHologramDetection":
      let idCapture = IdCapture()
      let enabled = arguments?["enabled"] as? Bool
      // defaults to false as this feature only supported for TUR_ID
      idCapture.setHologramDetection(enabled: enabled ?? false, result: result)
    case "uploadIDCapture":
      let idCapture = IdCapture()
      idCapture.upload(result: result)
   
    // AutoSelfie
    case "startAutoSelfie":
      let autoSelfie = AutoSelfie()
      let decoder = JSONDecoder()
      let iosArgs = arguments?["iosSettings"] as! String
      let autoSelfieSettings = try! decoder.decode(AutoSelfieSettings.self, from: Data(iosArgs.utf8))
      autoSelfie.start(settings: autoSelfieSettings, result: result)
    case "setAutoSelfieType":
      let autoSelfie = AutoSelfie()
      let type = arguments?["type"] as! String
      autoSelfie.setType(type: type, result: result)
    case "uploadAutoSelfie":
      let autoSelfie = AutoSelfie()
      autoSelfie.upload(result: result)
   

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  
}
