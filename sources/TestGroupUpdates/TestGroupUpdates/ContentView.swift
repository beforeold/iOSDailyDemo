import SwiftUI

class V1: ObservableObject {
  @Published var age = 1

  var completion: () -> Void = {}
}

class V2: ObservableObject {
  @Published var age = 5

  var completion: () -> Void = {}
}

struct SubView1: View {
  @ObservedObject var object: V1

  var body: some View {
    Text("v1: \(object.age)")
      .onTapGesture {
        self.object.completion()
      }
  }
}

struct SubView2: View {
  @ObservedObject var object: V2

  var body: some View {
    Text("v2: \(object.age)")
      .onTapGesture {
        self.object.completion()
      }
  }
}

class ViewModel: ObservableObject {
  enum Status {
    case v1(V1)
    case v2(V2)
    case v3(V1)
    case v4(V2)
  }

  @Published var status: Status = .v1(.init())

  init() {
    self.status = .v1(
      {
        let ins = V1()
        ins.completion = { [weak self] in self?.toggle() }
        return ins
      }()
    )
  }

  func toggle() {
    print(#function, self.status)

    if case .v1(let v1) = status {
      status = .v2(
        {
          let ins = V2()
          ins.completion = {
            self.toggle()
          }
          return ins
        }()
      )
    } else {
      status = .v1(
        {
          let ins = V1()
          ins.completion = { [weak self] in
            self?.toggle()
          }
          return ins
        }()
      )
    }
  }
}

struct Value: Identifiable {
  var id: UUID = .init()
  var view: AnyView
}

struct ContentView: View {
  @State private var item: Value?

  var body: some View {
    Button("show") {
      item = .init(view: AnyView(ContainerView(viewModel: .init())))
    }
    .fullScreenCover(item: $item) { item in
      // ContainerView(item: item)
      item.view
    }
  }
}

struct ContainerView: View {
  @ObservedObject var viewModel: ViewModel

  var body: some View {
    let _ = Self._printChanges()

    Group {
      let _ = print("group update")

      switch viewModel.status {
      case .v1(let v1):
        SubView1(object: v1)
      case .v2(let v2):
        SubView2(object: v2)
      case .v3(let v1):
        SubView1(object: v1)
      case .v4(let v2):
        SubView2(object: v2)
      }
    }
  }
}

#Preview {
  ContentView()
}
