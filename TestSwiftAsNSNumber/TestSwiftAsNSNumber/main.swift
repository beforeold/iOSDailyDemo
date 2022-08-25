//
//  main.swift
//  TestSwiftAsNSNumber
//
//  Created by dinglan on 2021/6/7.
//

import Foundation

print("Hello, World!")

let map: [String: Any] = [
    "a": 1.0,
    "b": 2 as NSNumber,
]


let value = map["b"]!
if value is Int {
    print("is int")
}

if value is NSNumber {
    print("is nsnumber")
}

if let a = value as? NSNumber {
    debugPrint(a)
}

