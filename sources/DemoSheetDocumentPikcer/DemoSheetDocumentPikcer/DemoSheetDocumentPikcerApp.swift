//
//  DemoSheetDocumentPikcerApp.swift
//  DemoSheetDocumentPikcer
//
//  Created by beforeold on 3/25/26.
//

import SwiftUI

@main
struct DemoSheetDocumentPikcerApp: App {
    init() {
        UISheetPresentationControllerHook.install()
        UISheetPresentationControllerHook.dumpAllMethods()
        UIApplicationTouchHook.setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
