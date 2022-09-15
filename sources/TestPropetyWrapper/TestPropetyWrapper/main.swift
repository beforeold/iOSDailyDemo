//
//  main.swift
//  TestPropetyWrapper
//
//  Created by BrookXy on 2022/3/22.
//

import Foundation

print("Hello, World!")


@propertyWrapper
struct Age18 {
    private var value: Int
    var wrappedValue: Int {
        set {
            if newValue < 18 {
                value = 18
            } else {
                value = newValue
            }
        }
        
        get {
            return value
        }
    }
    
    init(wrappedValue: Int) {
        self.value = wrappedValue > 18 ? wrappedValue : 18
    }
    
    func run() {
        
    }
}

class Person {
    @Age18 var age: Int = 0
    
    func foo() {
        _age.run()
    }
}


let p1 = Person()
print(p1.age)
p1.age = -18
print(p1.age)
