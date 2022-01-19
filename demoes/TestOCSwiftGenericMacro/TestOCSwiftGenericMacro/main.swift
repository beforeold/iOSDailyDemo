//
//  main.swift
//  TestOCSwiftGenericMacro
//
//  Created by 席萍萍Brook.dinglan on 2021/12/28.
//

import Foundation

print("Hello, World!")

class Dog: Animal {}

let p = Person<Dog>()
let dog = p.getPet()
