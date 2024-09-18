//import Observation
import ObservationBP
import SwiftUI

enum Option {
  case first
  case second
  case third
}

@Observable
class Model {
  var sections: [[Option]] = [
    [.first],
    [.second],
    []
  ]

  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//      self.append()
    })
  }

  func append() {
    sections[sections.count - 1] = [.third]
  }
}

struct Item<Value>: Identifiable {
  var index: Int
  var value: Value

  var id: Int { index }
}

extension Array {
  func mapped() -> [Item<Element>] {
    self.enumerated().map { index, value in
      Item(index: index, value: value)
    }
  }
}

struct ContentView: ViewBP {
  let model: Model = .init()

  var bodyBP: some View {
    List {
      Button("Append") {
        model.append()
      }

      ForEach(model.sections.mapped()) { section in
        ObservationView {
          Section {
            ForEach(section.value.mapped()) { item in
              Text("\(item.value)")
            }
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
