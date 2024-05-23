//
//  main.swift
//  TestModuleStringFilter
//
//  Created by Brook_Mobius on 11/27/23.
//

import Foundation

enum SomeEnum {
  case someCase
}

print(SomeEnum.someCase)
print("Hello, World!: \(SomeEnum.someCase)")

debugPrint(SomeEnum.someCase)
debugPrint("Hello, World!: \(SomeEnum.someCase)")

print("\n")

func printBridge(_ value: Any) {
  let bridge = value as? (any _ObjectiveCBridgeable)
  if let bridge {
    print("bridge: \(bridge)")
  } else {
    print("failed to brige")
  }
}

printBridge(SomeEnum.someCase)
printBridge(5)
printBridge(5.5)
printBridge(true)
printBridge("ok")
