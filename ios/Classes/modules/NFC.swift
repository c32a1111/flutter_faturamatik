import Flutter
import FaturamatikVerify

class NFC {
  private let module = Faturamatik.sharedInstance.scanNFC()
  private var moduleView: UIView?

  // func start(imageData: FlutterStandardTypedData, result: @escaping FlutterResult) {
  //   module.start(imageBase64: imageData.data.base64EncodedString()) { (_) in
  //       result(true)
  //   }
  // }

   func start(nviData: NviModel, result: @escaping FlutterResult) async {
    do {
      let nfcRequest = try await module.start(nviData: nviData)
      let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(nfcRequest),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
           let dictionary = jsonObject as? [String: Any] {
            result(dictionary)
        } else {
            result(FlutterError(code: "30008", message: "Serialization error", details: nil))
        }


      //  result(response)
        
    } catch let err {
        result(FlutterError(code: "30007", message: err.localizedDescription, details: nil))
    }
}

  // func start(result: @escaping FlutterResult) {
  //   let vc = UIApplication.shared.windows.last?.rootViewController

    
  //   moduleView = module.start { _ in
  //     result(true)
  //   }
  //   DispatchQueue.main.async {
  //     vc!.view.addSubview(self.moduleView)
  //     vc!.view.bringSubviewToFront(self.moduleView)
  //     vc!.navigationController?.setNavigationBarHidden(true, animated: false)
  //   }
  // }
  
  func setType(type: String, result: @escaping FlutterResult) {
    module.setType(type: type)
    result(nil)
  }
  
  func upload(result: @escaping FlutterResult) {
    module.upload { isSuccess in
      result(isSuccess)
    }
  }
  
}
