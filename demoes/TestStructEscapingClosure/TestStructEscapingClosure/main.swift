//
//  main.swift
//  TestStructEscapingClosure
//
//  Created by BrookXy on 2022/1/12.
//

import Foundation

func observe(_ closure: @escaping () -> Void) { }

struct Center {
    static var shared = Center()
    
    mutating func parse() { }
    
    init() {
        parse()
        
        observe {
             Center.shared.parse()
//            parse()
        }
    }
}

