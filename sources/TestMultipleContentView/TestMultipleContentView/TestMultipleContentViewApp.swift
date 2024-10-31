import SwiftUI

@main
struct TestMultipleContentViewApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

private struct ContentView: View {
  var body: Text = Text("")
}
