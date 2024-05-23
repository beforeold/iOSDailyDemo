//
//  ContentView.swift
//  TestSwiftUIViewLifecycle
//
//  Created by xipingping on 4/28/24.
//

import SwiftUI

class Model {
  let index: Int
  let count: Int

  init(index: Int, count: Int) {
    self.index = index
    self.count = count
    print("model init \(self.index) count: \(self.count)")
  }

  deinit {
    print("model deeeeeeeeeeeeeeeeeinit \(self.index) count: \(self.count)")
  }
}

struct CustomViewUI: UIViewRepresentable {
  var index: Int
  var count: Int

  class MyLabel: UILabel {
    var index: Int = 0
    var count: Int = 0

    override init(frame: CGRect) {
      super.init(frame: frame)

      print("model init")
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

    deinit {
      print("model deeeeeeeeeeeeeeeeeinit \(self.index) count: \(self.count)")
    }
  }

  func makeUIView(context: Context) -> MyLabel {
    MyLabel()
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.index = self.index
    uiView.count = self.count
  }

}

struct CustomView: View {
  @State private var model: Model

  let index: Int

  init(index: Int, count: Int) {
    print("CustomView init \(index) count: \(count)")

    let model = Model(index: index, count: count)
//    self.model = model
    self._model = State(wrappedValue: model)
    self._model = State(wrappedValue: model)
    self.index = index
  }

  var body: some View {
    Text("row \(index) count: \(self.model.count)")
      .frame(height: 100)
      .onDisappear {
        print("⚠️ disappear", index)
      }
  }
}

struct ContentView: View {
  @State private var count = 0

  var body: some View {
    ScrollView {
      Button("tap count: \(self.count)") {
        self.count += 1
      }

      LazyVStack {
        ForEach(0..<100) { index in
          CustomView(index: index, count: self.count)
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
