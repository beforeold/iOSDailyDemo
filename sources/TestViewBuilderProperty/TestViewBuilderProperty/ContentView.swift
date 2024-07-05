//
//  ContentView.swift
//  TestViewBuilderProperty
//
//  Created by xipingping on 7/5/24.
//

import SwiftUI

struct Split<Content: View>: View {
//  @ViewBuilder var content: () -> Content

  var content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    content
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Split {
        Text("hello")
      }

    }
    .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
