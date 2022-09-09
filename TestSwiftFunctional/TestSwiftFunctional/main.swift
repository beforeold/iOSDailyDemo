//
//  main.swift
//  TestSwiftFunctional
//
//  Created by Brook on 2019/10/30.
//  Copyright © 2019 br. All rights reserved.
//

import Foundation



infix operator <*>: AdditionPrecedence

func <*><Input, Output>(_ fn: ((Input) -> Output)?, _ value: Input?) -> Output? {
    guard let fn = fn, let value = value else { return nil }
    return fn(value)
}

let ret = Optional<(Int) -> Int>.some({ $0 * 2})
    <*>
    Optional<Int>.some(3)
print(ret as Any)

func biggerThanPower2(value: Int) -> (Int) -> Bool {
    return { $0 > value * value}
}

let array = [1, 5, 10]
print(array.filter(biggerThanPower2(value: 1)))
print(array.filter(biggerThanPower2(value: 2)))
print(array.filter(biggerThanPower2(value: 3)))


print("end")


prefix func ! <T>(_ originalFunction: @escaping (T) -> Bool) -> (T) -> Bool
{
    { !(originalFunction($0)) }
}

print(array.filter(!biggerThanPower2(value: 5)))

func exchangeParam<A, B, C>(_ originalFunction: @escaping (A, B) -> C) -> (B, A) -> C
{
    { originalFunction($1, $0) }
}

func curry<A, B, C>(_ originalFunction: @escaping (A, B) -> C) -> (A) -> (B) -> C
{
    { a in { b in originalFunction(a, b) } }
}

func add(_ a: Int, _ b: Int) -> Int {
    a + b
}

func minus(_ a: Int, _ b: Int) -> Int {
    a - b
}

print(curry(add)(3)(4))
print(curry(minus)(5)(2))

let moreThan9 = curry(exchangeParam(>))(9)
print(moreThan9(10))
print(moreThan9(8))


func niceFunc(_ a: Int, _ b: Int) -> Int {
    return a * a + b
}

let dd = exchangeParam(/)(4, 8)
print(dd)

let dd1 = niceFunc(3, 4)
let dd2 = exchangeParam(niceFunc)(4, 3)
print(dd1, dd2)
