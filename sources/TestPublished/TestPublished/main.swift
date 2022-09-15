//
//  main.swift
//  TestPublished
//
//  Created by dinglan on 2021/5/9.
//

import Foundation
import Combine

print("Hello, World!")


class Person {
    @Published
    var name = "Brook"
}

let per = Person()
let p1 = per.$name
let p2 = per.$name
let n1 = per.name
print(n1)
debugPrint(p1, p2)

let cc = p1.sink { s in
    print(s)
}

