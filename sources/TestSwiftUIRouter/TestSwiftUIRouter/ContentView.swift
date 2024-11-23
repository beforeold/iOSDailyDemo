import Observation
import SwiftUI

enum Tab {
  case home
}

enum Dest {
  case feed
}

@Observable
class Router {
  var paths: [Tab: [Dest]] = [:]

  subscript(tab: Tab) -> [Dest] {
    get { paths[tab] ?? [] }
    set { paths[tab] = newValue }
  }
}

struct ContentView: View {
  @Bindable var router: Router = .init()

  var body: some View {
    let _ = print("outer body")

    NavigationStack(path: $router[.home]) {
      let _ = print("NavigationStack root")

      Button("push") {
        print("push")
        router[.home].append(.feed)
      }
      .navigationDestination(for: Dest.self) { dest in
        Text("dest")
      }
    }
  }
}

#Preview {
  ContentView()
}
