# Counter Greeting Design

## Scope

Update `DemoHelloWorld` from a static starter screen into a small interaction-state demo.
All app and test changes stay under `sources/DemoHelloWorld/`.

## User Experience

The screen remains a single SwiftUI view. It presents a grouped-background page with
one compact content card and two controls:

- A sparkle symbol.
- A greeting title such as `Hello, DemoHelloWorld`.
- A counter status line such as `Tapped 0 times`.
- A primary `Tap` button.
- A secondary `Reset` button.

Initial state:

- Greeting is `Hello, DemoHelloWorld`.
- Counter reads `Tapped 0 times`.

Tap behavior:

- Increments the counter by one.
- Advances the greeting through a fixed list.
- Uses singular copy for `Tapped 1 time` and plural copy otherwise.

Reset behavior:

- Restores the counter to zero.
- Restores the first greeting.

## Architecture

Keep state local to `ContentView` because this demo has one screen and no shared
dependencies. Use SwiftUI value state:

- `tapCount: Int`
- `greetingIndex: Int`

Expose behavior through small private helpers on `ContentView`:

- `currentGreeting`
- `counterText`
- `advanceGreeting()`
- `reset()`

No external dependencies, persistence, networking, navigation, or global app state
are needed.

## UI Details

Follow the root `DESIGN.md` intent:

- Use grouped background.
- Use white card surfaces.
- Use the repository blue as the primary action color.
- Use the blue-green accent only for lightweight state emphasis.
- Respect Dynamic Type by using SwiftUI text styles.
- Keep touch targets at least 44 points high.

Add accessibility identifiers for automation:

- `greetingLabel`
- `counterLabel`
- `tapButton`
- `resetButton`

## Testing

Add a local UI test target for `DemoHelloWorld`.

The UI test verifies:

- Initial greeting is visible.
- Initial counter is visible.
- Tapping `Tap` changes the counter to `Tapped 1 time`.
- Tapping `Tap` changes the greeting from the initial greeting.
- Tapping `Reset` restores the initial greeting and counter.

Final verification should use XcodeBuildMCP:

- Build, install, and launch the app on an iOS simulator.
- Inspect the UI hierarchy for expected labels and controls.
- Capture a screenshot.
- Drive the tap/reset flow if UI automation tools are available.

## Out Of Scope

- Multiple screens.
- User text input.
- Persistence across launches.
- Animations beyond native SwiftUI control feedback.
- Root-level repo changes.
