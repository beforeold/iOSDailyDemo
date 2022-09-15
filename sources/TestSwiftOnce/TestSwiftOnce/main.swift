//
//  main.swift
//  TestSwiftOnce
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation


extension Bool {
    mutating func once(handler: () -> Void) {
        if self { return }
        handler()
        self = true
    }
}

var ok = false

class Person {
    var flag = false
}

let p = Person()

p.flag.once {
    print("once \(p)", p)
}
print(p.flag)
