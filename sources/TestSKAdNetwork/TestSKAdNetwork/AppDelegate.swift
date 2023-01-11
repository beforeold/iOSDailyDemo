//
//  AppDelegate.swift
//  TestSKAdNetwork
//
//  Created by Brook_Mobius on 2023/1/9.
//

import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
//    SKAdNetwork.updatePostbackConversionValue(1) { error in
//      print("updatePostbackConversionValue", error?.localizedDescription ?? "null localizedDescription")
//    }
//     SKAdNetwork.updatePostbackConversionValue(1, coarseValue: .high)
    if #available(iOS 16.1, *) {
      SKAdNetwork.updatePostbackConversionValue(1, coarseValue: .high, lockWindow: false) { error in
        print("updatePostbackConversionValue", error?.localizedDescription ?? "null localizedDescription")
      }
    } else {
      // Fallback on earlier versions
    }
    
    return true
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

