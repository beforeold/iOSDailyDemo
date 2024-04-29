//
//  ContentView.swift
//  TestPublsihed2
//
//  Created by xipingping on 4/29/24.
//

import Combine
import SwiftUI

class Model {
  @Published var count = 0

  var bag: Set<AnyCancellable> = []
}

struct ContentView: View {
  let model = Model()

  var body: some View {
    VStack {
      Button {
        self.model.count += 1
      } label: {
        Text("Tap Me")
      }
    }
    .padding()
    .onAppear {
      self.model.$count.sink { willChangeToValue in
        print("current value", self.model.count)
        print("value will chagne to", willChangeToValue)
      }
      .store(in: &self.model.bag)
    }
  }
}

#Preview {
  ContentView()
}
