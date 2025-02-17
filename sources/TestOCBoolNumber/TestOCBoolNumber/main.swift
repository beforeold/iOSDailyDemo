//
//  main.swift
//  TestOCBoolNumber
//
//  Created by Brook_Mobius on 2/17/25.
//

import Foundation

let boolValue: Bool = true
let boolNumber2: NSNumber = NSNumber(value: true)
let boolNumber3: NSNumber = NSNumber(value: 1)

OCObject.print(boolValue as NSNumber)
OCObject.print(boolNumber2)
OCObject.print(boolNumber3)

let json = ["value": boolValue]
let json2 = ["value": boolNumber2]
let json3 = ["value": boolNumber3]

func printJson(_ object: [String: Any]) {
  do {
    let data = try JSONSerialization.data(withJSONObject: object)
    print("json:", String(decoding: data, as: UTF8.self))
  } catch {
    print("failed", error)
  }
}

printJson(json)
printJson(json2)
printJson(json3)
