//
//  main.swift
//  TestProtocolExtensionType
//
//  Created by dinglan on 2021/6/6.
//

import Foundation
import Combine
import SwiftUI

print("Hello, World!")


struct Woo: Identifiable {
    let id = UUID()
    let name = ""
}

_ = List([Woo()]) {
    Text($0.name)
}

_ = Just(5)

_ = Publishers.Sequence<[Int], Never>(sequence: [5])

protocol Doublable {
    func doubling() -> Self
    func halving() -> Self
}

@propertyWrapper
struct Doubled<T: Doublable> {
    var number: T
    var wrappedValue: T {
        get { number.doubling() }
        set { number = newValue.halving() }
    }
    init(wrappedValue: T) {
        self.number = wrappedValue
    }
}

@propertyWrapper
struct Tripled<T: Doublable> {
    var number: T
    var wrappedValue: T {
        get { number.doubling().doubling()}
        set { number = newValue.halving().halving() }
    }
    init(wrappedValue: T) {
        self.number = wrappedValue
    }
}

extension Int: Doublable {
    func doubling() -> Int {
        return self * 2
    }

    func halving() -> Int {
        return Int(self / 2)
    }
}

extension Doubled: Doublable {
    func doubling() -> Self {
        return Doubled(wrappedValue: self.wrappedValue)
    }

    func halving() -> Self {
        return Doubled(wrappedValue: self.wrappedValue)
    }
}

struct Test {
    @Tripled @Doubled var value: Int = 10
}

var test = Test()
print(test.value) // prints 40
