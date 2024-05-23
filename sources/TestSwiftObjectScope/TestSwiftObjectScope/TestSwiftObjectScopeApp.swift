//
//  TestSwiftObjectScopeApp.swift
//  TestSwiftObjectScope
//
//  Created by beforeold on 5/12/24.
//

import SwiftUI

@main
struct TestSwiftObjectScopeApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(model: .init(age: 5))
        }
    }
}
