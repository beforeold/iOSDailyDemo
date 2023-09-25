//
//  main.swift
//  TestTrimLines
//
//  Created by Brook_Mobius on 9/20/23.
//

import Foundation

let temp = string.split(separator: "\n").filter { !$0.isEmpty }
let ret = temp.joined(separator: "\n")
assert(temp.count == 343)

print(ret)
