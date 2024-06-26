//
//  ContentView.swift
//  TestButtonStyle
//
//  Created by xipingping on 6/26/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    Button("Start", systemImage: "play.circle") {
      print("start")
    }
    .buttonStyle(GrowingButton())
  }
}

struct MonospacedButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    print(configuration)

    return configuration.label
      .padding()
      .foregroundStyle(.tint)
      .background(.yellow, in: Capsule())
      .fontDesign(.rounded)
  }
}

struct GrowingButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .background(.blue)
      .foregroundStyle(.white)
      .clipShape(Capsule())
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
