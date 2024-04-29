//
//  TestCustomEnvironmentObjectApp.swift
//  TestCustomEnvironmentObject
//
//  Created by beforeold on 2023/11/19.
//

import SwiftUI

@main
struct TestCustomEnvironmentObjectApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .customEnvironmentObject(SampleObjectA())
        .customEnvironmentObject(SampleObjectB())
    }
  }
}
