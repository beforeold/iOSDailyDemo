//
//  main.swift
//  TestClosureAndFunction
//
//  Created by Brook_Mobius on 12/21/23.
//

import Foundation

struct SomeClient {
  var foo: (_ flag: Bool) -> Void
  
  func foo(flag: Bool) {
    print("call foo function \(flag)")
  }

  var bar: () -> Void

  // func bar() { }
}


let client = SomeClient { flag in
  print("foo", flag)
} bar: {
  print("bar")
}

client.foo(true)
client.foo(flag: true)

client.bar()

