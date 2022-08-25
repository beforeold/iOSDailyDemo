//
//  main.swift
//  TestClassLet
//
//  Created by BrookXy on 2022/1/8.
//

import Foundation

print("Hello, World!")

protocol Mutating {
    mutating func foo()
}

class Person {
    static let shard = Person()
}

extension Person: Mutating {
    func foo() {
        print("fff")
    }
}

Person.shard.foo()

protocol Resettable {
  init()
}

extension Resettable {
  mutating func reset() {
    self = type(of: self).init()
  }
}

class A: Resettable, CustomDebugStringConvertible {
    
  required convenience init() { self.init(value: 0) }
  init(value: Int) { self.value = value }
  var value: Int
  var debugDescription: String { return "\(type(of: self)): \(self.value)" }
}
class B: A {}

var a: A = B(value: 1)
let orig = a
debugPrint(a)
a.reset()
debugPrint(a)
debugPrint(orig)
