import SwiftUI
//import App

class Router: ObservableObject {
  @Published var path: [String] = []
}

struct ObserableView<Content: View>: View {
  @ViewBuilder
  var content: () -> Content

  var body: some View {
    content()
  }
}

@Observable
class Router2 {
  var path: [String] = []
}

struct ContentView: View {
  // @StateObject private var router: Router = .init()
  // @Bindable var router: Router2 = .init()

  @MyBindable var router: Router2 = .init()

  @State private var path: [String] = []

  var body: some View {
    let _ = print("body")

    ObserableView {
      NavigationStack(path: $path) {
        let _ = print("root view")

        VStack {
          Text("push")
        }
        .padding()
        .onTapGesture {
          path  = ["hello"]
        }
        .navigationDestination(for: String.self) { value in
          Text("result: \(value)")
        }
      }
    }
  }
}

#Preview {
  ContentView()
}

@propertyWrapper
struct MyBindable<V: Observable> {
  var wrappedValue: V

  var projectedValue: Self {
    self
  }

  subscript<S>(keyPath: ReferenceWritableKeyPath<V, S>) -> Binding<S> {
    .init(
      get: { self.wrappedValue[keyPath: keyPath] },
      set: { self.wrappedValue[keyPath: keyPath] = $0 }
    )
  }
}
