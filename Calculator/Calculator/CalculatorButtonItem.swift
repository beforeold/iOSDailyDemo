//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by Brook on 2019/11/3.
//  Copyright © 2019 br. All rights reserved.
//

import Foundation
import CoreGraphics

enum CalculatorButtonItem {
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem {
    var title: String {
        switch self {
        case .digit(let val): return String(val)
        case .dot: return "."
        case .op(let oper): return oper.rawValue
        case .command(let cmd): return cmd.rawValue
        }
    }
    
    var size: CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
    var backgroundColorName: String {
        switch self {
        case .digit, .dot: return "digitBackground"
        case .op: return "operatorBackground"
        case .command: return "commandBackground"
        }
    }
    
    var foregroundColorName: String? {
        if case .command = self {
            return "commandForeground"
        }
        return nil
    }
}

extension CalculatorButtonItem: Hashable {}
