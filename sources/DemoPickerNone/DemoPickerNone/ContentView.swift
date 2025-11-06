//
//  ContentView.swift
//  DemoPickerNone
//
//  Created by beforeold on 2025/11/6.
//

import SwiftUI

enum Number: String, CaseIterable {
  case one = "One"
  case two = "Two"
  case three = "Three"
}

struct ContentView: View {
  @State private var selected: Number?

  var body: some View {
    VStack(spacing: 20) {
      Text("Picker Demo")
        .font(.title)
        .padding()

      Picker("Select a number", selection: $selected) {
        Text("None").tag(Number?.none)
        ForEach(Number.allCases, id: \.self) { number in
          Text(number.rawValue).tag(Optional(number))
        }
      }
      .pickerStyle(.segmented)
      .padding()

      if let selected = selected {
        Text("Selected: \(selected.rawValue)")
          .font(.headline)
          .foregroundColor(.blue)
      } else {
        Text("No selection")
          .font(.headline)
          .foregroundColor(.gray)
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
