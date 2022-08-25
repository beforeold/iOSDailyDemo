//
//  main.swift
//  TestSwiftSubclass
//
//  Created by 席萍萍Brook.dinglan on 2021/11/9.
//

import Foundation


let root = try? RootModel(jsonDictionary: ["person": ["name":"brook"]])

print("Hello, World!")
print(root?.person?.model as Any)

