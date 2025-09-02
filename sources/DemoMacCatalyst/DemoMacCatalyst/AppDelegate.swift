import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Override point for customization after application launch.
    
    #if targetEnvironment(macCatalyst)
    setupMacFeatures()
    #endif
    
    return true
  }
  
  #if targetEnvironment(macCatalyst)
  private func setupMacFeatures() {
    // 设置Mac专有的窗口标题
    DispatchQueue.main.async {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let window = windowScene.windows.first {
        window.windowScene?.title = "DemoMacCatalyst - Mac专有功能演示"
      }
    }
    
    // 设置Mac专有的功能
    setupMacSpecificFeatures()
  }
  
  private func setupMacSpecificFeatures() {
    // 在Mac Catalyst中，我们可以使用一些Mac专有的功能
    print("Mac专有功能已启用：")
    print("• Mac风格的窗口标题")
    print("• Mac原生交互体验")
    print("• 系统集成")
    print("• 键盘快捷键支持（通过UIKeyCommand）")
    
    // 发送通知给ViewController，告知Mac专有功能已启用
    NotificationCenter.default.post(name: NSNotification.Name("MacFeaturesEnabled"), object: nil)
  }
  #endif

  // MARK: UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
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
