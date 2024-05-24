//
//  ContentView.swift
//  TestNewTemplate2
//
//  Created by xipingping on 5/24/24.
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
