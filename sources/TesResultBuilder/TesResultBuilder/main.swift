//
//  main.swift
//  TesResultBuilder
//
//  Created by Brook_Mobius on 2023/4/6.
//

import Foundation

print("Hello, World!")

@resultBuilder struct Measured {
//  static func buildPartialBlock<Component>(first: Component) -> Component {
//    return first
//  }
  
//  static func buildPartialBlock<C>(accumulated: C, next: C) -> C {
//    return next
//  }
  
  static func buildBlock<T>(_ components: Any...) -> T {
    print("build block:", components)
    return components.last as! T
  }
}

@Measured
func foo() -> Int {
  let value = 5
  let v2 = value * 2
  print(v2)
  
  v2
}

@Measured
func bar() {
  let array = [1, 2, 3]
  let sum = array.reduce(0, +)
  print(sum)
}

let ret = foo()
print("ret:", ret)

bar()
