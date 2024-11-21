import SwiftUI
import App

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

//@Observable
//class Router2 {
//  var path: [String] = []
//}

import Perception
@Perceptible
class Router3 {
  var path: [String] = []
}

struct ContentView: View {
  // @StateObject private var router: Router = .init()
  // @Bindable var router: Router2 = .init()

  @Perception.Bindable var router: Router3 = .init()

  // @State private var path: [String] = []

  var body: some View {
    let _ = print("body")

    NavigationStack(path: $router.path) {
      let _ = print("root view")

      VStack {
        Button("push") {
          router.path = ["hello"]
        }
      }
      .padding()
      .navigationDestination(for: String.self) { value in
        Text("result: \(value)")
      }
    }
  }
}

#Preview {
  ContentView()
}

@propertyWrapper
@dynamicMemberLookup
public struct BindableBP<Value> where Value: AnyObject, Value: Perceptible {
  public var wrappedValue: Value

  public init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }

  public var projectedValue: BindableBP<Value> {
    self
  }

  public subscript<Subject>(
    dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
  ) -> Binding<Subject> {
    return Binding<Subject>(
      get: {
        print("bindable get")
        return self.wrappedValue[keyPath: keyPath]
      },
      set: { value in
        print("bindable set", value)
        self.wrappedValue[keyPath: keyPath] = value
      }
    )
  }
}
