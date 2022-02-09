//
//  main.swift
//  TestSwiftCurrying
//
//  Created by BrookXy on 2022/2/9.
//

import Foundation

func foo() -> () -> () -> () {
    return {
        return {
            print("foo called")
            print()
        }
    }
}


foo()()()


