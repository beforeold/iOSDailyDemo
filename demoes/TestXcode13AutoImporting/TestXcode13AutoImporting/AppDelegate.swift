//
//  AppDelegate.swift
//  TestXcode13AutoImporting
//
//  Created by 席萍萍Brook.dinglan on 2021/11/2.
//

import Cocoa
import MyFramework

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func foo() {
        _ = PublicFile(name: "nice")
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

