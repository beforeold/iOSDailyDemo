//
//  ContentView.swift
//  TestLazyVStack
//
//  Created by xipingping on 4/24/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading) {
        ForEach(0...100, id: \.self) { value in
          Text("Row \(value)")
            .frame(height: 200)
            .onAppear {
              print("appear", value)
            }
            .onDisappear {
              print("disappear", value)
            }
        }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
