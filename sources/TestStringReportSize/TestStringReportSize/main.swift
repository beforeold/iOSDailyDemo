//
//  main.swift
//  TestStringReportSize
//
//  Created by Brook_Mobius on 10/24/23.
//

import Foundation

extension String {

  func resizedImageURL(width: Int, height: Int, scale: Int = 2) -> String {
    var dots = components(separatedBy: ".")
    guard dots.count >= 2 else {
      return self
    }
    guard let suffix = dots.last else {
      return self
    }
    dots.removeLast()
    let prefix = dots.joined(separator: ".")
    var underlines = prefix.components(separatedBy: "_")
    if underlines.count >= 3 {
      underlines.removeLast(2)
      return underlines.joined(separator: "_") + "_\(width)_\(height)." + suffix
    } else {
      return prefix + "_\(width)_\(height)." + suffix
    }
  }
}

let originalString = "https://img.mobiuspace.com/image/aigc/e253b5c8dc9c2742389ea34a4e1e468e.webp?reportSize=600_800"
let resized = originalString.resizedImageURL(width: 600, height: 800)

print("ret: \(resized)")
