//
//  main.swift
//  TestDecimalDivide
//
//  Created by Brook_Mobius on 5/5/23.
//

import Foundation

extension Decimal {
  static func calculatePercentage(_ dividend: Decimal, _ divisor: Decimal) -> Int {
    var result = dividend / divisor * 100
    var rounded = Decimal()
    NSDecimalRound(&rounded, &result, 0, .down)
    let intValue = (rounded as NSDecimalNumber).intValue // This is now 100
    
    return intValue
  }
}

let ret = Decimal.calculatePercentage(1.99, 3.99)
print(ret)
