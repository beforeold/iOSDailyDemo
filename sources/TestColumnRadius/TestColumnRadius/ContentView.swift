//
//  ContentView.swift
//  TestColumnRadius
//
//  Created by Brook_Mobius on 12/25/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      HStack(spacing: 16) {
        VStack {
          ForEach(0..<100) { _ in
            Color.blue.frame(height: 200)
              .cornerRadius(32)
          }
        }

        VStack {
          ForEach(0..<100) { _ in
            Color.blue.frame(height: 200)
              .cornerRadius(32)
          }
        }
      }
      .padding(24)
    }
    .mask {
      HStack(spacing: 16) {
        RoundedRectangle(cornerRadius: 32)
          .frame(maxWidth: .infinity, maxHeight: .infinity)

        RoundedRectangle(cornerRadius: 32)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .padding(24)
    }
  }
}

#Preview {
  ContentView()
}

struct ShapeMaskingView: View {
  @State private var circleScale: CGFloat = 1.0  // Scale of the circle mask

  var body: some View {
    VStack {
      Image(systemName: "gear")
        .resizable()
        .frame(width: 200, height: 200)
        .mask(
          HStack {
            Circle()  // Masking the image with a circle
              //              .scaleEffect(circleScale)  // Scale the circle mask based on the slider value
              .frame(width: 200, height: 200)

            Circle()  // Masking the image with a circle
              //              .scaleEffect(circleScale)  // Scale the circle mask based on the slider value
              .frame(width: 200, height: 200)
          }
        )
        .animation(.easeInOut, value: circleScale)  // Smoothly animate the change in the mask size

      // Slider to adjust the size of the circle mask
      Slider(value: $circleScale, in: 0...1)
        .padding()
    }
  }
}

#Preview {
  ShapeMaskingView()
}
