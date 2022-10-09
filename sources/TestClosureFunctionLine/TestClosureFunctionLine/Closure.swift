//
//  Closure.swift
//  TestClosureFunctionLine
//
//  Created by beforeold on 2022/10/9.
//

import Foundation

//@objc
class Closure: NSObject {
    @objc static func test() {
        let closure = { (value: Int) in
            print("swift", value, #function, #line)
        }
        closure(5)
    }
}
