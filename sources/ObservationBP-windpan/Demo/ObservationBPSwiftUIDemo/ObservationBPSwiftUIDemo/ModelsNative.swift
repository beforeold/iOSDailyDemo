//
//  Models17.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/10/20.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable final class Person17 {
    var name: String
    var age: Int
    var list: [String] = []

    var getName: String {
        name
    }

    deinit {
        print("Person17 deinit: \(name)")
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age

        var list: [Int] = []
        for i in 0 ..< 5 {
            list.append(i)
        }
        self.list = list.map { "\($0)" }
    }
}

final class Person13: ObservableObject {
    @Published var name: String
    @Published var age: Int
    @Published var list: [String] = []

    deinit {
        print("Person13 deinit: \(name)")
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age

        var list: [Int] = []
        for i in 0 ..< 5 {
            list.append(i)
        }
        self.list = list.map { "\($0)" }
    }
}

@available(iOS 17.0, *)
@Observable final class Clz17 {
    var name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Clz17 deinit: \(name)")
    }
}
