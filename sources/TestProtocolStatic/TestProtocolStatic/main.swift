//
//  main.swift
//  TestProtocolStatic
//
//  Created by Brook_Mobius on 9/13/23.
//

import Foundation




@propertyWrapper
struct Storage<T> {

  private let key: String
  private let defaultValue: T

  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get {
      if T.self is Storagable {

      }

      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      if let value = newValue as? OptionalProtocol, value.isNil() {
        UserDefaults.standard.removeObject(forKey: key)
      } else {
        UserDefaults.standard.set(newValue, forKey: key)
      }
    }
  }

}

private protocol OptionalProtocol {
  func isNil() -> Bool
}


protocol Storagable: Codable {

}


struct Value: Storagable {

}

func foo() {
  if Value.Type is Storagable.Protocol {
    print("is Storagable")
  } else {
    print("test failed")
  }
}

foo()
