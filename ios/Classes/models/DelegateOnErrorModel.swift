//
//  DelegateOnErrorModel.swift
//  flutter_faturamatik
//
//  Created by Bedri Doğan on 25.03.2025
//

import Foundation
import FaturamatikVerify

struct DelegateOnErrorModel: Codable {
  let type: String
  let errors: [FaturamatikError]
}
