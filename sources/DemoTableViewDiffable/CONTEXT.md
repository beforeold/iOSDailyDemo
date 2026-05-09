# DemoTableViewDiffable Context

This demo is isolated from other demos.

Agents may edit only files under this directory unless explicitly instructed.

Feature scope:

- UIKit `UITableView`
- `UITableViewDiffableDataSource`
- trailing swipe delete
- editing-mode row reordering

Build command:

```sh
xcodegen generate --spec project.yml
xcodebuild -project DemoTableViewDiffable.xcodeproj -scheme DemoTableViewDiffable -destination 'generic/platform=iOS Simulator' build
```

Sandbox-friendly compile check:

```sh
xcodebuild -project DemoTableViewDiffable.xcodeproj -scheme DemoTableViewDiffable -destination 'generic/platform=iOS' -derivedDataPath /private/tmp/DemoTableViewDiffableDerivedData CODE_SIGNING_ALLOWED=NO build
```
