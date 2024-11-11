import SwiftUI


class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    return true
  }

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    print("can perform action", action, sender as Any)

    return true
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function, touches.randomElement()!)
  }

}

@main
struct TestMenuEventApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
