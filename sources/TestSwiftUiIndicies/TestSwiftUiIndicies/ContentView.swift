
import ObservationBP
import SwiftUI

public struct ContentView: View {

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

  public var body: some View {
    ObservationView {
      content
    }
  }

  @ViewBuilder var content: some View {
    let _ = print("bp 1")

    List {
      let _ = print("list")

      Button("Append") {
        model.append()
      }

      ForEach(model.sections.indices, id: \.self) { item in
        let _ = print("outer foreach \(item)")
        let index = item
        Section {
          ForEach(model.sections[index].indices, id: \.self) { item in
            let _ = print("inner foreach \(item)")

            let index2 = item
            Text("\(model.sections[index][index2])")
          }
        }
      }
    }
  }
}


import ObservationBP

public struct ObsView<Content> {
  @State var id = 0

  let content: () -> Content

  public var body: Content {
    let _ = self.id
    return withObservationTracking {
      content()
    } onChange: { [_id = UncheckedSendable(self._id)] in
      _id.value.wrappedValue &+= 1
    }
  }
}

extension ObsView: View where Content: View {
  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
}


#Preview {
  ContentView()
}
