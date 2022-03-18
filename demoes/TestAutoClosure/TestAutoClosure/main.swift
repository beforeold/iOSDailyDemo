//
//  main.swift
//  TestAutoClosure
//
//  Created by BrookXy on 2022/3/19.
//

import Foundation


var customersInLine = ["First", "Second"]

func serve(customer: @autoclosure () -> String) {
    print("next -> \(customer())")
}

serve(customer: customersInLine.remove(at: 0))

print(customersInLine.count)

var name: String? = "ok"

var ret = name ?? customersInLine.remove(at: 0)
print(ret)

print(customersInLine.count)
