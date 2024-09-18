import Foundation
import ObservationBP
import SwiftUI

struct ContentViewIndexed: View {

  enum Option: Hashable {
    case first
    case second
    case third
  }

  @ObservationBP.Observable
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

  var model: Model = .init()

  var body: some View {
    ObservationView {
      let _ = print("bp 1")

      List {
        let _ = print("list")

        Button("Append") {
          model.append()
        }

        ForEach(model.sections.indiciesAndValues, id: \.index) { item in
          let _ = print("outer foreach \(item)")
          let index = item.index
          //        ObservationView {
          Section {
            ForEach(model.sections[index].indiciesAndValues, id: \.index) { item in
              let _ = print("inner foreach \(item)")

              let index2 = item.index
              Text("\(model.sections[index][index2])")
            }
          }

          //        }
        }
      }
    }
  }
}

#Preview {
  ContentViewIndexed()
}
