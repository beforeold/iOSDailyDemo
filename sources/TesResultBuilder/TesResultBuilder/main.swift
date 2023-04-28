//
//  main.swift
//  TesResultBuilder
//
//  Created by Brook_Mobius on 2023/4/6.
//

import Foundation

print("Hello, World!")

// buildPartialBlock for result builders – available from Swift 5.7 - https://www.hackingwithswift.com/swift/5.7/buildpartialblock

// Lift all limitations on variables in result builders – available from Swift 5.8 - https://www.hackingwithswift.com/swift/5.8/lift-result-builder-limitations

@resultBuilder struct Logged {
  static func buildBlock<C0, C1>(_ c0: @autoclosure () -> C0, _ c1: @autoclosure () -> C1 ) -> C1 {
    print("build block begin")

    _ = c0()
    let value = c1()
    
    print("build block end")
    return value
  }
}


@resultBuilder struct Measured {
//  static func buildPartialBlock<Component>(first: Component) -> Component {
//    return first
//  }
  
//  static func buildPartialBlock<C>(accumulated: C, next: C) -> C {
//    return next
//  }
  
  static func buildBlock<T>(_ components: Any...) -> T {
    print("build block components:", components)
    return components.last as! T
  }
}

@Measured
func getValue(_ value: Int) -> Int {
  value
}

@Measured
func foo() -> Int {
  let value = 5
  let v2 = value * 2
  print(v2)
  
  getValue(v2)
  
  let v3 = v2 + 5
  print(v3)
  
  getValue(v3)
  
  v3
}

@Measured
func bar() {
  let array = [1, 2, 3]
  let sum = array.reduce(0, +)
  print(sum)
}

let ret = foo()
print("ret:", ret)

print("")

bar()



@Logged
func forLog() {
  let value = 5
  print("for log \(value)")
  print("ok")
}

print("")
forLog()
