import SwiftUI


struct PublishedView: View {
  enum Option: Hashable {
    case first
    case second
    case third
  }

  class Model: ObservableObject {
    @Published var sections: [[Option]] = [
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

  @StateObject var model: Model = .init()

  var body: some View {
    let _ = print("bp 1")

    List {
      let _ = print("list")

      Button("Append") {
        model.append()
      }

      ForEach(model.sections.indices, id: \.self) { item in
        let _ = print("outer foreach \(item)")

        let index = item
        //        ObservationView {
        Section {
          ForEach(model.sections[index].indices, id: \.self) { item in
            let _ = print("inner foreach \(item)")

            let index2 = item
            Text("\(model.sections[index][index2])")
          }
        }
        //        }
      }
    }
  }
}

#Preview {
  PublishedView()
}
