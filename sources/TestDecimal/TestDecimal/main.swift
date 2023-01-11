//
//  main.swift
//  TestDecimal
//
//  Created by Brook_Mobius on 2023/1/10.
//

import Foundation

var week: Decimal = 3.99
var year: Decimal = 39.99
let weekDayPrice = week / 7
let lifetimeDayPrice = year / 365 / 2
let saved = (weekDayPrice - lifetimeDayPrice) / weekDayPrice
// let string = String(format: "Saved %d%%", saved as CVarArg)

let formatter = NumberFormatter()
formatter.numberStyle = .percent
formatter.minimumIntegerDigits = 2
formatter.maximumIntegerDigits = 2
formatter.maximumFractionDigits = 0

let string = formatter.string(from: saved as NSNumber)

print(string!)
