import SwiftUI

@main
struct TestArticleSplitApp: App {
  @StateObject private var appViewModel = AppViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $appViewModel.navigationPath) {
        InputView(appViewModel: appViewModel)
          .navigationDestination(for: Content.self) { content in
            ContentView2(
              appViewModel: appViewModel,
              content: content
            )
          }
      }
    }
  }
}
