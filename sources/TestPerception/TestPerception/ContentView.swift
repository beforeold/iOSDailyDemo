//
//  ContentView.swift
//  TestPerception
//
//  Created by Brook_Mobius on 1/11/24.
//

import SwiftUI
import Perception

@Perceptible class Model {
  var name = "name"
}

struct ContentView: View {
  let model = Model()

  @State var valueList = [1, 2, 3]

  var body: some View {
    WithPerceptionTracking {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)

        Text("Hello, world!")

        let name = self.model.name

        ForEach(self.valueList, id: \.self) { value in
//          WithPerceptionTracking {
            Text("name: \(name), \(value)")
//          }
        }

        Button("change name") {
          self.model.name = "name: \(self.valueList.randomElement()!)"
        }
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
