//
//  main.swift
//  TestStringUtf8Data
//
//  Created by 席萍萍Brook.dinglan on 2021/11/30.
//

import Foundation

let str: String = "hello world😸"

let data1 = str.data(using: .utf8) ?? Data()
print(data1.count)

let data2 = Data(str.utf8)
print(data2.count)

print("is data1 == data2:", data1 == data2)

