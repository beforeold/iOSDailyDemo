//
//  CalculatorModel.swift
//  Calculator
//
//  Created by brook.dinglan on 2020/8/11.
//  Copyright © 2020 OneV's Den. All rights reserved.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
    var objectWillChange = PassthroughSubject<Void, Never>()
}
