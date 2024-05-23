//
//  ContentView.swift
//  TestSwiftuiEnumerated
//
//  Created by Brook_Mobius on 4/19/24.
//

import SwiftUI

struct Model: Identifiable {
  var id: Int
}

struct ContentView: View {
  let data: [Model] = []

  var body: some View {
    List {
      ForEach(data.enumerated(), id: \.element.id) { index, element in
        Text("hello")
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
