import SwiftUI

struct BindingView<Value, Content: View>: View {
  private var content: (Binding<Value>) -> Content
  init(
    initialValue: Value,
    content: @escaping (Binding<Value>) -> Content
  ) {
    self._value = State(wrappedValue: initialValue)
    self.content = content
  }

  @State private var value: Value

  var body: some View {
    content($value)
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
  BindingView(
    initialValue: false
  ) { binding in
    Toggle("Toggle", isOn: binding)
  }
  .padding()
}
