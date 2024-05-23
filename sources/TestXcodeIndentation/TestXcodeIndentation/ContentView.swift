//
//  ContentView.swift
//  TestXcodeIndentation
//
//  Created by beforeold on 5/23/24.
//

import SwiftUI

// customize process: Xcode settings -> Text Editing -> Indentation
struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
