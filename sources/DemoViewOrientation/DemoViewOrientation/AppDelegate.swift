import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    if OrientationManager.shared.isFullScreenPresented {
      return .all
    } else {
      return .portrait
    }
  }
}

