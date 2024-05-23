//
//  main.swift
//  TestIntJSONArray
//
//  Created by Brook_Mobius on 11/29/23.
//

import Foundation

print("Hello, World!")

let array = [1, 2, 3]

let data = try? JSONEncoder().encode(array)
let string = data.flatMap {
  String(data: $0, encoding: .utf8)
}
print("ret: \(string ?? "null")")
