//
//  main.swift
//  TestApply
//
//  Created by beforeold on 02/06/23.
//

import Foundation

struct Begin<T> {
  let value: T
  init(_ value: T) {
    self.value = value
  }
}

extension Begin {
  func apply(_ action: (T) -> Void) -> Self {
    action(value)
    return self
  }
}


/// Thenable API
extension Begin {
  func then(_ action: (T) -> Void) -> T {
    action(value)
    return value
  }
  
  func `do`(_ action: (T) -> Void) {
    action(value)
  }
  
  func with(_ action: (inout T) -> Void) -> T {
    var value = value
    action(&value)
    return value
  }
}


func apply<T>(_ value: T, _ action: (T) -> Void) -> T {
  action(value)
  
  return value
}


let value: Int = Begin(5).then { value in
  print(value)
}

let v2 = apply(5) { value in
  print(value)
}

print(v2)
