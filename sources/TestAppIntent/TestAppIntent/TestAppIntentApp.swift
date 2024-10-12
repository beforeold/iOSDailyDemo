import AppIntents
import SwiftUI

@main
struct TestAppIntentApp: App {
  init() {
    AppDependencyManager.shared.add(dependency: Object.shared)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
