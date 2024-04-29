//
//  ContentView.swift
//  TesrMultiplatform20231031
//
//  Created by beforeold on 2023/10/31.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    Group {
#if os(visionOS)
      ImmersiveSpace {
        Text("content")
      }
#else
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
          .font(.extraLargeTitle2)
        Text("Hello, world!")
      }
      .padding()
#endif
    }
    
  }
}

#Preview {
  ContentView()
}
