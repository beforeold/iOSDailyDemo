//
//  ContentView.swift
//  TestSPMLoading
//
//  Created by beforeold on 2023/10/1.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
      
      KFImage(URL(string: ""))
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
