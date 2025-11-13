import SwiftUI

@main
struct DemoMacHelloApp: App {
  var body: some Scene {
    MenuBarExtra("Hello", systemImage: "star.fill") {
      Button("Hello World") {
        print("Hello World")
      }
      Divider()
      Button("Quit") {
        NSApplication.shared.terminate(nil)
      }
      .keyboardShortcut("q")
    }
  }
}
