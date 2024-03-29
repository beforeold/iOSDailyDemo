//
//  ContentView.swift
//  TestSwiftUIShape
//
//  Created by xipingping on 3/29/24.
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

/// a progress view with a circle hud
public struct ProgressHUD: View {
  public init() {

  }

  public var body: some View {
    ZStack {
      Circle()
        .fill(Color.black.opacity(0.4))

      ProgressView()
    }
  }
}

#Preview {
  VStack {
    ProgressHUD()
  }
  .frame(width: 40, height: 40)
  .frame(width: 100, height: 100)
  .background(Color.blue)
  .preferredColorScheme(.dark)
}
