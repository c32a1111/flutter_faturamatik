//
//  ImageProvider.swift
//  faturamatik_flutter
//
//  Created by Bedri Doğan on 25.03.2025.
import Foundation
import UIKit

public class ImageProvider {
  public static func image(named: String) -> UIImage? {
    return UIImage(named: named, in: Bundle(for: self), compatibleWith: nil)
  }
}
