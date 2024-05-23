//
//  ContentView.swift
//  TestObservationBPEnvironment
//
//  Created by xipingping on 4/28/24.
//

import SwiftUI
import ObservationBP

@Observable
class Model {
  var count = 0
}

struct CustomView: ViewBP {
  @Environment(Model.self) var model

  var bodyBP: some View {
    Button("Tap to increase") {
      self.model.count += 1
    }

    Text("Count: \(self.model.count)")
  }
}

struct ContentView: ViewBP {
  var bodyBP: some View {
    VStack {
      CustomView()
    }
    .padding()
    .environment(Model())
  }
}

#Preview {
  ContentView()
}
