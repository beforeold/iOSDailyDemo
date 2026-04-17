//
//  ContentView.swift
//  DemoDoubleToJSON
//
//  Created by beforeold on 4/17/26.
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
    .onAppear {
      do {
        let map: [String: Any] = [
//          "double.nan": Double.nan,
//          "Double.infinity": Double.infinity,
//          "-Double.infinity": -Double.infinity,
          "demo": 1,
        ]
        if JSONSerialization.isValidJSONObject(map) {
          print("valid json")
        } else {
          print("invalid json")
          return
        }
        let data = try JSONSerialization.data(withJSONObject: map)
        print("encode success, count", data.count)
      } catch {
        print("failed to encode", error)
      }
    }
  }
}

#Preview {
  ContentView()
}
