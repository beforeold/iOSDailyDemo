//
//  Reducer.swift
//  TestMVI
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

struct Reducer {
    func getNextState() -> State {
        let current = Store.shared.value
        let index = (current.index + 1) % current.employee.count
        return AppState(employee: current.employee, index: index)
    }
}
