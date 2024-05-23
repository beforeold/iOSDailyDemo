//
//  main.swift
//  TestStructVarInit
//
//  Created by beforeold on 5/23/24.
//

import Foundation

struct Person {
  var age: Int
  
  init(age: Int) {
    self.age = age
    print("init struct", self.age)
  }
}

let p1 = Person(age: 1)
var p2 = p1
print("p2 age", p2.age)

