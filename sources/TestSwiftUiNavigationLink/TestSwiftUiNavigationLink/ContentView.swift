//
//  ContentView.swift
//  TestSwiftUiNavigationLink
//
//  Created by beforeold on 4/28/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      ForEach(0..<5) { index in
        Button {
          print("tap \(index)")
        } label: {
          Text("row \(index)")
        }
      }
    }
    .tint(.white)
  }
}

#Preview {
  NavigationStack {
    ContentView()
  }
}
