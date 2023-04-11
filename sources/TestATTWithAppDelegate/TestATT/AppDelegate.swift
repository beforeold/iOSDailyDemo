//
//  AppDelegate.swift
//  TestATT
//
//  Created by Brook_Mobius on 2023/4/11.
//

import UIKit
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    print(#function)
    
    let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://apple.com")!)) { data, response, error in
      print("is response nil", response == nil)
    }
    task.resume()
    
//    requestATT()
    return
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.requestATT()
    }
  }
  
  func requestATT() {
    ATTrackingManager.requestTrackingAuthorization { status in
      print(#function, "staus", status.rawValue)
      
      DispatchQueue.main.async {
        //        self.button.setTitle("Click to request, ret \(status)", for: .normal)
      }
    }
  }
  
}

