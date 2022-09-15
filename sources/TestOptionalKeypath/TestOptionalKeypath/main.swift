//
//  main.swift
//  TestOptionalKeypath
//
//  Created by BrookXy on 2022/4/13.
//

import Foundation

print("Hello, World!")

extension Optional {
    subscript(keyPath keyPath: KeyPath<Wrapped, String>) -> String {
        if let val = self {
            return val[keyPath: keyPath]
        }
        
        return ""
    }
}


struct Model {
    var name: String
}

func foo() {
    let model1: Model? = Model(name: "brook")
    let model2: Model = Model(name: "brook")
    print(model1[keyPath: \.name])
    print(model2[keyPath: \.name])
}

foo()
