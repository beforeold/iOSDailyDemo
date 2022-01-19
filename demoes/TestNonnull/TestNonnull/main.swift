//
//  main.swift
//  TestNonnull
//
//  Created by 席萍萍Brook.dinglan on 2021/9/15.
//

import Foundation

func receive(str: String) {
    print("ret = " + str)
}

print("Hello, World!")

if let name = Person.name() {
    receive(str: name)
}

receive(str: Person.name())

