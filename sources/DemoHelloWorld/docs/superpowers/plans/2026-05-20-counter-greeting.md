# Counter Greeting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `DemoHelloWorld` into a small SwiftUI interaction-state demo with tap and reset behavior.

**Architecture:** Keep all app state local to `ContentView` using SwiftUI `@State`. Add one UI test target through XcodeGen so the interaction can be verified automatically on an iOS simulator.

**Tech Stack:** SwiftUI, XCTest UI tests, XcodeGen, XcodeBuildMCP.

---

## File Structure

- Modify `sources/DemoHelloWorld/project.yml` to add a UI test target and explicit scheme test action.
- Modify `sources/DemoHelloWorld/DemoHelloWorld/ContentView.swift` to implement the Counter + Greeting UI.
- Create `sources/DemoHelloWorld/DemoHelloWorldUITests/DemoHelloWorldUITests.swift` for automated UI coverage.
- Regenerate `sources/DemoHelloWorld/DemoHelloWorld.xcodeproj` with `xcodegen generate --spec sources/DemoHelloWorld/project.yml`.

### Task 1: Add A Failing UI Test

**Files:**
- Modify: `sources/DemoHelloWorld/project.yml`
- Create: `sources/DemoHelloWorld/DemoHelloWorldUITests/DemoHelloWorldUITests.swift`

- [ ] **Step 1: Add the UI test target to `project.yml`**

Use this full file content:

```yaml
name: DemoHelloWorld
options:
  bundleIdPrefix: com.example
  deploymentTarget:
    iOS: "16.0"
settings:
  base:
    SWIFT_VERSION: 5.9
targets:
  DemoHelloWorld:
    type: application
    platform: iOS
    deploymentTarget: "16.0"
    sources:
      - path: DemoHelloWorld
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.example.demohelloworld
        INFOPLIST_FILE: DemoHelloWorld/Info.plist
  DemoHelloWorldUITests:
    type: bundle.ui-testing
    platform: iOS
    deploymentTarget: "16.0"
    sources:
      - path: DemoHelloWorldUITests
    dependencies:
      - target: DemoHelloWorld
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.example.demohelloworld.uitests
schemes:
  DemoHelloWorld:
    build:
      targets:
        DemoHelloWorld: all
    run:
      config: Debug
    test:
      config: Debug
      targets:
        - name: DemoHelloWorldUITests
```

- [ ] **Step 2: Create the UI test file**

Use this full file content:

```swift
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
```

- [ ] **Step 3: Regenerate the project**

Run:

```sh
xcodegen generate --spec sources/DemoHelloWorld/project.yml
```

Expected: XcodeGen reports project generation and `DemoHelloWorld.xcodeproj` now includes `DemoHelloWorldUITests`.

- [ ] **Step 4: Run the UI test and verify RED**

Run through XcodeBuildMCP `test_sim` or equivalent scoped command:

```sh
xcodebuild -project sources/DemoHelloWorld/DemoHelloWorld.xcodeproj -scheme DemoHelloWorld -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath /private/tmp/DemoHelloWorldMCPDerivedData CODE_SIGNING_ALLOWED=NO test
```

Expected: test fails because the current app does not expose `greetingLabel`, `counterLabel`, `tapButton`, or `resetButton`.

### Task 2: Implement Counter + Greeting

**Files:**
- Modify: `sources/DemoHelloWorld/DemoHelloWorld/ContentView.swift`

- [ ] **Step 1: Replace `ContentView.swift` with the interactive view**

Use this full file content:

```swift
import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    @State private var greetingIndex = 0

    private let greetings = ["Hello", "Welcome", "Nice Tap"]

    private var currentGreeting: String {
        "\(greetings[greetingIndex]), DemoHelloWorld"
    }

    private var counterText: String {
        tapCount == 1 ? "Tapped 1 time" : "Tapped \(tapCount) times"
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                greetingCard
                controls
            }
            .padding(24)
            .frame(maxWidth: 420)
        }
    }

    private var greetingCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(Color(red: 0, green: 0.34, blue: 0.72))
                .accessibilityLabel("Sparkle")

            Text(currentGreeting)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("greetingLabel")

            Text(counterText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tapCount == 0 ? .secondary : Color(red: 0.04, green: 0.5, blue: 0.49))
                .accessibilityIdentifier("counterLabel")
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                advanceGreeting()
            } label: {
                Label("Tap", systemImage: "hand.tap.fill")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0, green: 0.34, blue: 0.72))
            .accessibilityIdentifier("tapButton")

            Button {
                reset()
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.bordered)
            .tint(Color(red: 0, green: 0.34, blue: 0.72))
            .accessibilityIdentifier("resetButton")
        }
    }

    private func advanceGreeting() {
        tapCount += 1
        greetingIndex = (greetingIndex + 1) % greetings.count
    }

    private func reset() {
        tapCount = 0
        greetingIndex = 0
    }
}
```

- [ ] **Step 2: Run the UI test and verify GREEN**

Run:

```sh
xcodebuild -project sources/DemoHelloWorld/DemoHelloWorld.xcodeproj -scheme DemoHelloWorld -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath /private/tmp/DemoHelloWorldMCPDerivedData CODE_SIGNING_ALLOWED=NO test
```

Expected: `DemoHelloWorldUITests.testTapAdvancesGreetingAndResetRestoresInitialState` passes.

### Task 3: Verify With XcodeBuildMCP UI Evidence

**Files:**
- No source changes.

- [ ] **Step 1: Build and launch with XcodeBuildMCP**

Use XcodeBuildMCP defaults for:

- Project: `sources/DemoHelloWorld/DemoHelloWorld.xcodeproj`
- Scheme: `DemoHelloWorld`
- Bundle id: `com.example.demohelloworld`
- Simulator: an available iOS simulator

Run `build_run_sim` with `CODE_SIGNING_ALLOWED=NO`.

Expected: status `SUCCEEDED`.

- [ ] **Step 2: Capture UI hierarchy**

Run XcodeBuildMCP `snapshot_ui`.

Expected visible elements include:

- `Hello, DemoHelloWorld`
- `Tapped 0 times`
- `Tap`
- `Reset`

- [ ] **Step 3: Capture screenshot**

Run XcodeBuildMCP `screenshot`.

Expected: screenshot shows the Counter + Greeting card and both controls.

- [ ] **Step 4: Confirm demo-only changes**

Run:

```sh
git status --short sources/DemoHelloWorld
```

Expected: changes are limited to `sources/DemoHelloWorld/`.
