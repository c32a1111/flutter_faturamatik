//
//  AutoSelfieSettings.swift
//  faturamatik_flutter
//
//  Created by Bedri Doğan on 25.03.2025.

import Foundation


struct AutoSelfieSettings: Codable {
  // info messages
  var faceIsOk: String = "Lütfen sabit durun"
  var notInArea: String = "Yüzünüzü daire içine hizalayın"
  var faceTooSmall: String = "Yüzünüz çok uzakta"
  var faceTooBig: String = "Yüzünüz çok yakında"
  var completed: String = "İşlem Tamam"
  // screen config
  var appBackgroundColor: String = "000000"
  var appFontColor: String = "ffffff"
  var primaryButtonBackgroundColor: String = "ffffff"
  var ovalBorderSuccessColor: String = "00ff00"
  var ovalBorderColor: String = "ffffff"
  var countTimer: String = "3"
  var manualCropTimeout: Int = 30
}
