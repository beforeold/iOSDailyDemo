//
//  TestPreviewMacroApp.swift
//  TestPreviewMacro
//
//  Created by beforeold on 6/13/24.
//

import SwiftUI

@main
struct TestPreviewMacroApp: App {
  @State var flag = false
  var body: some Scene {
    WindowGroup {
      ContentView(flag: $flag)
    }
  }
}
