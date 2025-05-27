//
//  FaturamatikError+Extensions.swift
//  faturamatik_flutter
//
//  Created by Bedri Doğan on 25.03.2025.
//

import Foundation
import FaturamatikVerify

extension FaturamatikError {
  
  func toDictionary() -> [String: Any] {
    return [
      "error_code": self.error_code as Int,
      "error_message": self.error_message as Any
    ]
  }
  
}
