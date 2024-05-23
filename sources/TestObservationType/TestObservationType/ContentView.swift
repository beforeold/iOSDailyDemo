//
//  ContentView.swift
//  TestObservationType
//
//  Created by Brook_Mobius on 1/29/24.
//

import SwiftUI
import Observation

@Observable class Person {
  var name: String = "name"
}

struct NameView: View {
  let model: Person

  var body: some View {
    Text(self.model.name)
  }
}

struct ContentView: View {
  let model = Person()

  var body: some View {
    let _ = print("------ body")

    VStack(spacing: 30) {
      Button("change name") {
        self.model.name = "beforeold"
      }

      self.name
    }
    .padding()
  }

  var name: some View {
//    let text = Text(self.model.name)
//    print(text)
//    return text
    NameView(model: self.model)
  }
}

#Preview {
  ContentView()
}
