//
//  main.swift
//  TestAutoClosurePassing
//
//  Created by Brook_Mobius on 4/25/23.
//

import Foundation

func foo(_ value: @autoclosure () -> Int) {
  print("foo")
  
  // auto closure again
  // fine to call it
  bar(value())
}

func bar(_ value: @autoclosure () -> Int) {
  print("bar")
  print("bar value", value())
}

func provideValue() -> Int {
  print("provideValue")
  return 5
}

foo(provideValue())
