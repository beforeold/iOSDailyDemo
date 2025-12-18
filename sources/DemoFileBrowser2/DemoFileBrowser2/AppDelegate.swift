import UIKit

  @main
  class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UITabBarController.installTabBarHooks()
    startTabBarSweep()
    return true
  }

  private func startTabBarSweep() {
    // Periodically scan all windows for any UITabBar instances that slipped past lifecycle hooks.
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
      let windows = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }

      for window in windows {
        self.hideTabBars(in: window)
      }
    }
  }

  private func hideTabBars(in root: UIView?) {
    guard let root = root else { return }

    if let tabBar = root as? UITabBar {
      print("[TabBarHook] sweep hiding UITabBar", type(of: tabBar))
      tabBar.isHidden = true
    }

    for subview in root.subviews {
      hideTabBars(in: subview)
    }
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}
