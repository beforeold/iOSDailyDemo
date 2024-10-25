import XCTest
@testable import TestSPMTargets
import TestSPMTargetsCore

final class TestSPMTargetsTests: XCTestCase {
  func testExample() throws {
    // XCTest Documentation
    // https://developer.apple.com/documentation/xctest

    // Defining Test Cases and Test Methods
    // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods

    Full.foo()
    Core.foo()
  }
}
