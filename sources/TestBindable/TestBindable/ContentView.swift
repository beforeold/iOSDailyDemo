//
//  ContentView.swift
//  TestBindable
//
//  Created by xipingping on 5/23/24.
//

import SwiftUI
import Observation

@Observable final class Model {
  var age = 0
}

struct ContentView: View {
  @Bindable var model = Model()

  var body: some View {
    // get the model propety wrapper itself whioh is a Bindable
    let bindable = $model
    // bindable 内部没有一个其他私有存储属性，看起来就是直接持有了一个 Obserable
    // Perception 把问题搞复杂了
    // https://github.com/pointfreeco/swift-perception/blob/main/Sources/Perception/Bindable.swift
    let _ = print(bindable)

    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
