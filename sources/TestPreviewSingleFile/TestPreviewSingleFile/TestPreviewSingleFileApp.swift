import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print(#function)

    return true
  }
}

@main
struct TestPreviewSingleFileApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  init() {
    print("app init")
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
