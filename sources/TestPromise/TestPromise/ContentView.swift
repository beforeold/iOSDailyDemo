//
//  ContentView.swift
//  TestPromise
//
//  Created by Brook_Mobius on 2022/11/11.
//

import SwiftUI

class Promise<T> {
  typealias promise = (T) -> Void
  let builder: (@escaping promise) -> Void
  init(builder: @escaping (@escaping promise) -> Void) {
    self.builder = builder
  }
  
  func run(callback: @escaping (T) -> Void) {
    builder(callback)
  }
}

struct ContentView: View {
  @State var count = 0
  var body: some View {
    VStack {
      Text("count: \(count)")
      Button("Tap") {
        let count = count
        Promise { promise in
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise(count + 666)
          }
        }
        .run { int in
          self.count = int
        }
      }
    }
    .padding()
  }
}

func foo() {
  _ = Promise { callback in
    callback(5)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
