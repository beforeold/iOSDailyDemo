//
//  Reducer.swift
//  Calculator
//
//  Created by brook.dinglan on 2020/7/30.
//  Copyright © 2020 OneV's Den. All rights reserved.
//

import Foundation

typealias CalculatorState = CalculatorBrain
typealias CalculatorAction = CalculatorButtonItem

struct Reducer {
    static func reduce(state: CalculatorState,
                       action: CalculatorAction) -> CalculatorState
    {
        state.apply(item: action)
    }
}
