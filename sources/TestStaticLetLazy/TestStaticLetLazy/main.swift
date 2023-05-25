//
//  main.swift
//  TestStaticLetLazy
//
//  Created by Brook_Mobius on 5/25/23.
//

import Foundation

struct Value {
  static let value: Int = getValue()
  
  static func getValue() -> Int {
    print(#function)
    return 5
  }
}

print("begin")
print("value", Value.value)
print("end")

