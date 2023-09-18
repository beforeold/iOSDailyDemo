//
//  UIImage+Extension.swift
//  ImageChecker
//
//  Created by Brook_Mobius on 9/18/23.
//

import UIKit

extension UIImage {
  func fixOrientation() -> UIImage {
    if imageOrientation == .up { return self }
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    draw(in: rect)
    if let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() {
      UIGraphicsEndImageContext()
      return normalizedImage
    } else {
      return self
    }
  }
}
