import Combine
import SwiftUI

class Navigator {
  enum Action {
    case push(String)
    case pop
  }

  private let subject: PassthroughSubject<Action, Never> = .init()

  var actions: AnyPublisher<Action, Never> {
    subject.eraseToAnyPublisher()
  }

  private func send(_ action: Action) {
    subject.send(action)
  }

  func push(_ dest: String) {
    send(.push(dest))
  }

  func pop() {
    send(.pop)
  }

//  var onPathChanged: ([String]) -> Void = { _ in }
//  @Published var path: [String] = [] {
//    didSet {
//      print("didset", path)
//    }
//  }

  static let shared: Navigator = .init()

}

class ViewModel {
  var dest: String?

  func foo(completion: @escaping () -> Void) {
    // ...
    // push
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      completion()
    })
  }
}

struct HomeView: View {
  @State var path: [String] = []

  let viewModel = ViewModel()

  var body: some View {
    VStack {
      Text("path count \(path.count)")

      Button("sss") {
        viewModel.foo {
          path.append("foo")
        }
      }
      .padding(30)
    }
  }
}

#Preview {
  HomeView(path: [])
}

@main
struct TestNavigationStackRefreshApp: App {
  @State private var path: [String] = []

  init() {
//    Navigator.shared.onPathChanged = { [_path] path in
//      print(path)
//      //      _path.wrappedValue = path
//      self.path = path
//      print(_path.wrappedValue)
//    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView(path: $path)
        .onReceive(Navigator.shared.actions) { action in
          switch action {
          case .pop:
            path.removeLast()
          case .push(let dest):
            path.append(dest)
          }
        }
    }
  }
}
