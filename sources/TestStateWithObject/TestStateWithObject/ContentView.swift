//
//  ContentView.swift
//  TestStateWithObject
//
//  Created by xipingping on 3/19/24.
//

import SwiftUI

struct SubView: View {
  class Model: NSObject {
    var count = 0

    override init() {
      super.init()
      print("model init")
    }

    deinit {
      print("model deinit")
    }
  }

  @State var model: Model

  init() {
    let model = Model()
    print("init subview \(model)")
    self.model = model
  }

  var body: some View {
    VStack(spacing: 12) {
      let _ = print(model)

      Text("hello, \(model.count)")

      Button("+") {
        let model = Model()
        model.count = self.model.count + 1
        self.model = model
      }
    }
  }
}

struct ContentView: View {
  @State var count = 0

  var body: some View {
    VStack(spacing: 30) {
      Button("tap") {
        self.count += 1
      }

      Text("count: \(count)")

      Divider()

      SubView()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
