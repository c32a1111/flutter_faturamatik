import Flutter
import Foundation
import FaturamatikVerify

class DelegateEventHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
  
}
extension DelegateEventHandler: FaturamatikDelegate {
  public func onError(type: String, error: [FaturamatikVerify.FaturamatikError]) {
    do {
      let jsonData = try JSONEncoder().encode(error)
      let jsonString = String(data: jsonData, encoding: .utf8)
      let returnJsonString = try JSONEncoder().encode(["errorType": type, "errors": jsonString])
      eventSink?(["type": "error", "data": String(data: returnJsonString, encoding: .utf8)])
    } catch {
      eventSink?(["type": "error", "data": ["type": "JSONConversation", "errors": ["error_code": "30011", "error_message": "\(error.localizedDescription)"]] as [String: Any]])
    }
    
  }
}
extension DelegateEventHandler: mrzInfoDelegate {
   func mrzInfo(_ mrz: FaturamatikVerify.MRZModel?, documentId: String?) {
    print("STREAM HANDLER GUARD LET ILE MRZ KONTROLU YAPILACAK")
    guard let mrz = mrz else {
      print("GELEN MRZ INFO DATASI EXTENSION: \(mrz) ")
      eventSink?(["type": "error", "data": ["type": "JSONConversion", "errors": ["error_code": "30022", "error_message": "mrz model is nil"]] as [String: Any]])
      return
    }

    let nviData = FaturamatikVerify.NviModel(mrzModel: mrz)
    if nviData != nil {
      print("NviData nil check yapıldı ve eventSink ile dart tarafına gönderilecek. \(nviData)")
      eventSink?(["type": "mrzInfoDelegate", "data": String(describing: mrz)])
    } else {
      eventSink?(["type": "error", "data": ["type": "JSONConversion", "errors": ["error_code": "30021", "error_message": "Nvi model parsing error"]] as [String: Any]])
    }
  }
}