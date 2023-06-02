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
  
  func apply(_ action: (T) -> Void) -> Self {
    action(value)
    return self
  }
  
  func end() -> T {
    return value
  }
}


func apply<T>(_ value: T, _ action: (T) -> Void) -> T {
  action(value)
  
  return value
}


let value = Begin(5).apply { value in
  print(value)
}
.apply { value in
  print(value)
}
.end()
print(value)


let v2 = apply(5) { value in
  print(value)
}

print(v2)
