//
//  Animal.swift
//  TestProtocolExtension
//
//  Created by dinglan on 2021/4/26.
//

import Foundation


protocol Animal {
    func eat()
    func give() -> String
}

extension Animal {
    func eat() {
        print("Animal eat")
    }
    
    func run() {
        print("Animal run")
    }
    
    func give() -> String {
        "animal give"
    }
}

struct Person {
    
}

extension Person: Animal {
    func eat() {
        print("Person eat")
    }
    
    func run() {
        print("Person run")
    }
    
    func give() -> String {
        "person give"
    }
}

func foo() {
    
    let animal = Person() as? Animal
    animal?.eat()
    animal?.run()
    print(animal?.give())


    let list = [Person(), "String"] as [Any]

    list.forEach { (p) in
        if let ret = p as? Animal {
            ret.eat()
            print("ret: \(ret)")
        }
    }

}

