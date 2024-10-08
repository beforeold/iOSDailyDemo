//
//  ContentView.swift
//  TestViewBuilderProperty2
//
//  Created by xipingping on 9/26/24.
//

import SwiftUI

struct Card<Content: View>: View {
  @ViewBuilder var content: Content
  
  var body: some View {
    VStack {
      content
    }
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      
      Card {
        Text("Hello, world!")
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
