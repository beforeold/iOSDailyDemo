import SwiftUI

struct MyWrapper: DynamicProperty {
  class Object: ObservableObject {
    var age = 0
  }

  @ObservedObject private var object: Object = .init()

  var projectedValue: Binding<Int> {
    $object.age
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
