# DemoHelloWorld Context

This demo is isolated from other demos.

Agents may edit only files under this directory unless explicitly instructed.

Build command:

```sh
xcodegen generate --spec project.yml
xcodebuild -project DemoHelloWorld.xcodeproj -scheme DemoHelloWorld -destination 'generic/platform=iOS Simulator' build
```
