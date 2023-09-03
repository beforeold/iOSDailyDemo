//
//  CalculatorBrainTests.swift
//  CalculatorTests
//
//  Created by 王 巍 on 2019/07/19.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import XCTest
import Foundation
@testable import Calculator

class CalculatorBrainTests: XCTestCase {

    func testInitValue() {
        let v = CalculatorBrain.left("0")
        XCTAssertEqual(v.output, "0")
    }

    func testApplyLeftNum() {
        let v = CalculatorBrain.left("0")
        let result = v.apply(item: .digit(1))
        XCTAssertEqual(result.output, "1")
    }

    func testApplyLeftNumMul() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(1))
            .apply(item: .digit(2))
            .apply(item: .digit(3))
        XCTAssertEqual(result.output, "123")
    }

    func testApplyLeftNumDot() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(1))
            .apply(item: .dot)
            .apply(item: .digit(2))
            .apply(item: .digit(3))
        XCTAssertEqual(result.output, "1.23")
    }

    func testApplyLeftDotNum() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .dot)
            .apply(item: .digit(2))
            .apply(item: .digit(3))
        XCTAssertEqual(result.output, "0.23")
    }

    func testApplyLeftMulDotNum() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .dot)
            .apply(item: .digit(2))
            .apply(item: .dot)
            .apply(item: .digit(3))
            .apply(item: .dot)
        XCTAssertEqual(result.output, "0.23")
    }

    func testApplyOp() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(5))
            .apply(item: .op(.plus))
        XCTAssertEqual(result.output, "5")
    }

    func testApplyOpRight() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(5))
            .apply(item: .op(.plus))
            .apply(item: .digit(3))
        XCTAssertEqual(result.output, "3")
    }

    func testSimpleCalculate() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(5))
            .apply(item: .op(.plus))
            .apply(item: .digit(3))
            .apply(item: .op(.equal))
        XCTAssertEqual(result.output, "8")
    }

    func testDotCalculate() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(5))
            .apply(item: .dot)
            .apply(item: .digit(2))
            .apply(item: .op(.multiply))
            .apply(item: .digit(1))
            .apply(item: .dot)
            .apply(item: .digit(3))
            .apply(item: .op(.equal))
        XCTAssertEqual(result.output, "6.76")
    }

    func testOpChange() {
        let v = CalculatorBrain.left("0")
        let result = v
            .apply(item: .digit(2))
            .apply(item: .op(.multiply))
            .apply(item: .op(.plus))
            .apply(item: .digit(3))
            .apply(item: .op(.equal))
        XCTAssertEqual(result.output, "5")
    }
}
