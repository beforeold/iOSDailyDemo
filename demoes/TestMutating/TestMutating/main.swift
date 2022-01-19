//
//  main.swift
//  TestMutating
//
//  Created by BrookXy on 2022/1/12.
//

import Foundation

class Object {
    var person: Person {
        didSet {
            print("did set person")
        }
    }
    
    init(person: Person) {
        self.person = person
    }
}

struct Person {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    init() {
        self.name = ""
    }
    
    mutating func mutate(name: String) {
        self.name = name
    }
}

var p1 = Person(name: "brook")
p1.mutate(name: "nancy")
let p2 = p1
print(p2.name)

let obj = Object(person: .init(name: "brook"))
obj.person.mutate(name: "nancy")
