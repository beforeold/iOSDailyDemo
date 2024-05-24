//
//  ContentView.swift
//  TestWithSelf
//
//  Created by xipingping on 5/23/24.
//

import SwiftUI

public extension View {
  /// apply a builder to self
  func withSelf<C>(
    @ViewBuilder builder: (_ itself: Self) -> C
  ) -> C where C: View {
    builder(self)
  }
}


struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .withSelf { itself in
      itself.frame(width: 200)
    }
  }
}

#Preview {
  ContentView()
}
