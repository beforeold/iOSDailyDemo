//
//  ContentView.swift
//  TestHorizontalGrid
//
//  Created by Brook_Mobius on 1/6/25.
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

struct StylePlaceholderView: View {
  let items = Array(1...10)  // Example data

  let columns = [
    GridItem(.fixed(120), spacing: 8),
    GridItem(.fixed(120), spacing: 8),
  ]

  var body: some View {
    ScrollView(.horizontal) {
      LazyHGrid(rows: columns, alignment: .center, spacing: 8) {
        ForEach(items, id: \.self) { item in
          VStack(spacing: 8) {
            Color.blue
              .frame(width: 100, height: 100)
              .cornerRadius(10)

            Text("Item \(item)")
              .frame(height: 12)
          }
        }
      }
      .padding(.horizontal, 24)  // Horizontal inset for the grid
      .frame(height: 120 * 2 + 8)
      .background(Color.gray)
    }
  }
}

#Preview {
  StylePlaceholderView()
}
