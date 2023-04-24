//
//  main.swift
//  TestLazySet
//
//  Created by beforeold on 24/04/23.
//

import Foundation

private func provideName() -> String {
  print(#function)
  return "brook"
}


private func provideName2() -> String {
  print(#function)
  return "brook2"
}

class Person {
  var name2: String = provideName2()
  
  lazy var name: String = {
    return provideName()
  }()
}

let person = Person()
person.name = "Hank"
print("name:", person.name)

