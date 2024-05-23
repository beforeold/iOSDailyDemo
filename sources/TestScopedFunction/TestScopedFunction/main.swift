//
//  main.swift
//  TestScopedFunction
//
//  Created by xipingping on 5/11/24.
//

import Foundation

print("Hello, World!")

@propertyWrapper
struct Scoped<T> {
  var wrappedValue: T

  var projectedValue: Scoped<T> {
    self
  }
}

extension Scoped {
  func apply(_ block: (T) -> Void) {
    block(wrappedValue)
  }

  @discardableResult
  func then(_ block: (T) -> Void) -> Self {
    block(wrappedValue)
    return self
  }
}

protocol Thenable {
  associatedtype T

  func then(_ block: (T) -> Void) -> Self
}

struct SomeView: Thenable {
  typealias T = String

  @discardableResult
  func then(_ block: (T) -> Void) -> SomeView {
    self
  }
}

extension Scoped: Thenable {

}

class Model {
  @Scoped var count = 0

  func foo() {
    $count.apply { value in
      print(value)
    }

    @Scoped var age = 18
    // local variable 的 propety wrapper 的 code completion 支持很差
  }
}

func foo() {
  @Scoped var age = 5

  $age.apply { value in
    print("age", value)
  }

  let value = $age
  value.then { _ in

  }
  .then { _ in
  }
}

foo()

SomeView().then { _ in
  print("")
}

Scoped(wrappedValue: 5).then { value in
  print(value)
}
