/*
import Foundation
import ObservationBP
import SwiftUI

extension Array: @retroactive Identifiable where Element: Hashable {
  public var id: Element? {
    first
  }
}

public struct ContentViewIdentified: ViewBP {

  public enum Option: Hashable {
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

  public var bodyBP: some View {
    ObservationView {
      let _ = print("bp 1")

      List {
        let _ = print("list")

        Button("Append") {
          model.append()
        }

        ForEach(model.sections, id: \.self) { item in
          let _ = print("outer foreach \(item)")

          //        ObservationView {
          Section {
            ForEach(item.indices, id: \.self) { item2 in
              let _ = print("inner foreach \(item2)")

              let index2 = item2
              Text("\(item[index2])")
            }
          }
          //        }
        }
      }
    }
  }
}

#Preview {
  ContentViewIdentified()
}
*/
