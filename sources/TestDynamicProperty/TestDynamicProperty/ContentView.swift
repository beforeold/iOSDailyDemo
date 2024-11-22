import SwiftUI

@propertyWrapper
struct MyState: DynamicProperty {
  var wrappedValue: String {
    get { value }
    nonmutating set { value = newValue }
  }

  @State private var value: String

  init(wrappedValue: String) {
    self._value = State(wrappedValue: wrappedValue)

  }

//  func update() {
//    print(#function)
//  }
}

struct ContentView: View {
  @MyState private var name = "initial"

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("name: \(name)!")
    }
    .padding()
    .onTapGesture {
      name = "changed"
    }
  }
}

#Preview {
  ContentView()
}
