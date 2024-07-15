//
//  ContentView.swift
//  TestNewTemplate20240715
//
//  Created by xipingping on 7/15/24.
//

import SwiftUI

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
    .preferredColorScheme(.dark)
}
