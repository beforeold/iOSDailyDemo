import SwiftUI

struct Overlay: View {

  var text: String
  var body: some View {
    Text(text)
  }
}


import Observation

@Observable
class Model {
  var overlayText = ""
}

struct Item: Identifiable {
  var id: String { value }

  var value: String
}

struct ContentView: View {

  @State private var overlayShowing = false
//  @State private var overlayText = ""

  let model = Model()

  @State private var item: Item?

//  var overlayText: String {
//    get { model.overlayText }
//    nonmutating set { model.overlayText = newValue }
//  }

  var body: some View {
    Form {
      Button("Button 1") {
//        overlayText = "Button 1 was tapped"
        item = .init(value: "Button 1")
        overlayShowing = true
      }

      Button("Button 2") {
        // overlayText = "Button 2 was tapped"
        item = .init(value: "Button 2")
        overlayShowing = true
      }

      Button("Button 3") {
        // overlayText = "Button 3 was tapped"
        item = .init(value: "Button 3")
        overlayShowing = true
      }
    }
    .sheet(item: $item) { item in
      Overlay(text: item.value)
    }
  }
}

#Preview {
  ContentView()
}
