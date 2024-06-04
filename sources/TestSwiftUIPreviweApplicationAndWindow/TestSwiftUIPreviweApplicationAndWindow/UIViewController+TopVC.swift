//
//  UIViewController+TopVC.swift
//  TestSwiftUIPreviweApplicationAndWindow
//
//  Created by xipingping on 6/4/24.
//

import UIKit

extension UIViewController {
  
  private static func getRootViewController() -> UIViewController? {
    UIApplication.shared.windows.first?.rootViewController
  }
  
  /// topVC of the AppDelegate
  public static func topViewController() -> UIViewController? {
    let rootVC = getRootViewController()
    return getTopVC(vc: rootVC)
  }
  
  public static func getTopVC(vc: UIViewController?) -> UIViewController? {
    guard vc != nil else {
      debugPrint("找不到顶层控制器...")
      return nil
    }
    
    if let presentVc = vc?.presentedViewController {
      debugPrint("handle presentedViewController")
      //modal出来的控制器
      return getTopVC(vc: presentVc)
    }
    
    if let navVc = vc as? UINavigationController {
      debugPrint("handle UINavigationController")
      return getTopVC(vc: navVc.topViewController)
    }
    
    if let tabVc = vc as? UITabBarController {
      debugPrint("handle UITabBarController")
      if let selectedVc = tabVc.selectedViewController {
        debugPrint("handle UITabBarController selectedViewController")
        return getTopVC(vc: selectedVc)
      }
      return tabVc
    }
    
    debugPrint("handle vc")
    // 返回顶层控制器
    return vc
  }
}

extension UIWindow {
  static func currentWindow() -> UIWindow? {
    let window: UIWindow? = {
      if #available(iOS 13.0, *) {
        let activeScenes = UIApplication.shared.connectedScenes
          .filter({ $0.activationState == .foregroundActive })
          .compactMap({ $0 as? UIWindowScene })
        if let window = activeScenes.first?.windows.filter(\.isKeyWindow).first {
          print("currentWindow scene")
          return window
        } else if let window = UIApplication.shared.delegate?.window {
          print("currentWindow delegate")
          return window
        } else {
          print("currentWindow nil")
          return nil
        }
      } else {
        if let window = UIApplication.shared.delegate?.window {
          return window
        } else {
          return UIApplication.shared.windows.first
        }
      }
    }()
    
    return window
  }
}
