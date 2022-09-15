//
//  main.swift
//  TestMethodAsFunction
//
//  Created by BrookXy on 2022/2/9.
//

import Foundation

fileprivate enum MyEnum {
    case errorArg(Error)
    case noArg
    
    static func bar() {
        print("call type method -> \(self)")
    }
    
    func fizz() {
        print("call instance method: -> \(self)")
    }
}

func foo() {
    // (Error) -> MyEnum
    let errorArgClosure = MyEnum.errorArg
    print("error: ->", errorArgClosure)
    let value = errorArgClosure(NSError(domain: "domain", code: 666, userInfo: nil))
    print(value)
    print()
    
    // MyEnum
    let noArgProperty = MyEnum.noArg
    print(noArgProperty)
    print()
    
    // () -> ()
    let barClosure = MyEnum.bar
    print("bar: ->", barClosure)
    barClosure()
    print()
    
    // (MyEnum) -> () -> ()
    let fizzClosure = MyEnum.fizz
    print("fizz: ->", fizzClosure)
    fizzClosure(value)()
    print()
}
