import XCTest

final class DemoInAppPreviewDebugUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testDebugWorkflowUpdatesVisibleState() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Build iOS Apps Lab"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Pass UI Check"].exists)
        XCTAssertTrue(app.buttons["Record Event"].exists)
        XCTAssertTrue(app.buttons["Show Issue"].exists)

        app.buttons["Pass UI Check"].tap()
        XCTAssertTrue(app.staticTexts["UI check passed"].waitForExistence(timeout: 2))

        app.buttons["Record Event"].tap()
        XCTAssertTrue(app.staticTexts["Debug event recorded"].waitForExistence(timeout: 2))

        app.buttons["Show Issue"].tap()
        XCTAssertTrue(app.staticTexts["Needs review"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Recoverable issue shown"].waitForExistence(timeout: 2))
    }
}
