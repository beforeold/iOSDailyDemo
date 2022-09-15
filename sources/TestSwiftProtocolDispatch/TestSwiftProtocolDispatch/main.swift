//
//  main.swift
//  TestSwiftProtocolDispatch
//
//  Created by 席萍萍Brook.dinglan on 2021/11/22.
//

import Foundation

print("Hello, World!")


protocol SomeProtocol {
    func requiredOne()
}

extension SomeProtocol {
    func requiredOne() {
        print("default required one")
    }
}

extension SomeProtocol {
    func optionalOne() {
        print("default optional one")
    }
}

struct Student: SomeProtocol {
    func requiredOne() {
        print("student required")
    }
    
    func optionalOne() {
        print("student optional one")
    }
}

let stu = Student()
stu.optionalOne()

let pro = stu as SomeProtocol
pro.optionalOne()
