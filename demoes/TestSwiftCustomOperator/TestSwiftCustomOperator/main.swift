//
//  main.swift
//  TestSwiftCustomOperator
//
//  Created by BrookXy on 2022/2/9.
//

import Foundation

// MARK: -

infix operator ~>

func ~><T>(expression: @autoclosure () throws -> T,
           errorTransform: (Error) -> Error) throws -> T {
    do {
        return try expression()
    } catch {
        throw errorTransform(error)
    }
}

enum MyError: Error {
    case one(error: Error)
}

func fail() throws -> Int {
    return 5
}

func foo() throws {
    let int = try fail() ~> MyError.one
    print(int)
}

// MARK: -

/// Miscellaneous Symbols
/// https://jrgraphix.net/r/Unicode/2600-26FF
postfix operator ☉

postfix func ☉(value: Int?) -> Int {
    return value ?? 0
}

var int: Int? = 4
print(int☉)
print(int☉ as Any)

print("Hello, World!")

