//
//  main.swift
//  TestSwiftToolchain
//
//  Created by dinglan on 2021/6/2.
//

import Foundation


@propertyWrapper
struct Same<T> {
    var value: T
    
    init(wrappedValue: T) {
        self.value = wrappedValue
    }
    
    var wrappedValue: T {
        set {
            self.value = newValue
        }
        
        get {
            value
        }
    }
}

//
//@_functionBuilder
//struct Builder {
//
//}

@resultBuilder
struct NewBuilder<T> {
    static func buildBlock(_ components: T...) -> T {
        return components[0]
    }
}


func foo() {
    @Same
    var someValue = 5
    print(someValue)
}

foo()
