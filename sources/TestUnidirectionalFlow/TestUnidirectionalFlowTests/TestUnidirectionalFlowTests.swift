//
//  TestUnidirectionalFlowTests.swift
//  TestUnidirectionalFlowTests
//
//  Created by Brook_Mobius on 11/1/23.
//

import XCTest
@testable import TestUnidirectionalFlow

final class TestUnidirectionalFlowTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testAdd() throws {
    let state = ShopState(products: [])
    let newState = reduce(state, .add("p1"))
    XCTAssertEqual(newState.products, ["p1"])
  }

  func testRemove() throws {
    let state = ShopState(products: ["p1", "p2", "p3"])
    let newState = reduce(state, .remove("p2"))
    XCTAssertEqual(newState.products, ["p1", "p3"])
  }

}
