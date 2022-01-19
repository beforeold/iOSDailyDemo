//
//  Model.swift
//  TestMVI
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation


struct Employee {
    var name: String
}

protocol State {
    var employee: [Employee] { get }
    var index: Int { get }
}

struct InitialState: State {
    var employee: [Employee] = [
        Employee(name: "Brook"),
        Employee(name: "Nancy"),
        Employee(name: "Sarah"),
    ]
    
    var index = 0
}

struct AppState: State {
    var employee: [Employee]
    var index: Int
}
