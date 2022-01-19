//
//  AppDelegate.swift
//  TestAMapLocation
//
//  Created by dinglan on 2021/5/28.
//

import UIKit
import AMapLocationKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func foo() {
        [1, 2].publisher.zip([3, 4].publisher)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let manager = AMapLocationManager()
        manager.desiredAccuracy = CLLocationAccuracy.init(200)
        manager.locationTimeout = 5
        manager.reGeocodeTimeout = 10
        manager.requestLocation(withReGeocode: true) { (location, regeo, error) in
            _ = manager.description
            print(error)
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

