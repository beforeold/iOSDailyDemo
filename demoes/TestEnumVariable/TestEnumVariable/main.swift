//
//  main.swift
//  TestEnumVariable
//
//  Created by BrookXy on 2022/1/19.
//

import Foundation

// variadic


enum Measure: String, CaseIterable {
    case code, msg
}

func foo(_ strings: String...) {
    
}

// Cannot pass array of type '[String]' as variadic arguments of type 'String'
 // foo(Measure.allCases.map { $0.rawValue })

/*
// Cannot convert return expression of type '(T...) -> R' to return type '([T]) -> R'
func trans<T, R>( _ fun: @escaping (T...) -> R) -> ([T]) -> R {
    return { list in
        fun
    }
}

let array = [""]
let retF = trans(foo)

*/
