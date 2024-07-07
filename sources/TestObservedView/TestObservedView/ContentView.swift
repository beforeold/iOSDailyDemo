//
//  ContentView.swift
//  TestObservedView
//
//  Created by beforeold on 7/7/24.
//

import SwiftUI

public struct ObservedView<Model, Content>: View
where Model: ObservableObject, Content: View {

  @ObservedObject var model: Model

  @ViewBuilder var builder: (_ model: Model) -> Content

  public init(
    model: Model,
    @ViewBuilder builder: @escaping (_ model: Model) -> Content
  ) {
    self.model = model
    self.builder = builder
  }

  public var body: some View {
    builder(model)
  }
}

class Model: ObservableObject {
  @Published var name = ""

  init(name: String = "") {
    self.name = name
  }
}

struct View1: View {
  var name: String

  var body: some View {
    Text("view1 \(name)")
  }
}

struct View2: View {
  var name: String

  var body: some View {
    Text("view2 \(name)")
  }
}

struct ContentView: View {
  let models: [Model] = [
    .init(name: "1"),
    .init(name: "2")
  ]

  var body: some View {
    VStack(spacing: 20) {
      ObservedView(model: models[0]) { model in
        View1(name: model.name)
          .onTapGesture {
            model.name += "_v1"
          }
      }

      ObservedView(model: models[1]) { model in
        View1(name: model.name)
          .onTapGesture {
            model.name += "_v2"
          }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}

