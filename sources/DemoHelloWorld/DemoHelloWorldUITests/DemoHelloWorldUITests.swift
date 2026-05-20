import XCTest

final class DemoHelloWorldUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testTapAdvancesGreetingAndResetRestoresInitialState() throws {
        let app = XCUIApplication()
        app.launch()

        let greetingLabel = app.staticTexts["greetingLabel"]
        let counterLabel = app.staticTexts["counterLabel"]
        let tapButton = app.buttons["tapButton"]
        let resetButton = app.buttons["resetButton"]

        XCTAssertTrue(greetingLabel.waitForExistence(timeout: 3))
        XCTAssertEqual(greetingLabel.label, "Hello, DemoHelloWorld")
        XCTAssertEqual(counterLabel.label, "Tapped 0 times")

        XCTAssertTrue(tapButton.waitForExistence(timeout: 2))
        tapButton.tap()

        XCTAssertEqual(counterLabel.label, "Tapped 1 time")
        XCTAssertEqual(greetingLabel.label, "Welcome, DemoHelloWorld")

        XCTAssertTrue(resetButton.waitForExistence(timeout: 2))
        resetButton.tap()

        XCTAssertEqual(greetingLabel.label, "Hello, DemoHelloWorld")
        XCTAssertEqual(counterLabel.label, "Tapped 0 times")
    }
}
