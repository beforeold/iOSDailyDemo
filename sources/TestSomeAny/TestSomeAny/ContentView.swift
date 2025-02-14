import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      AnyView(anyView)
    }
    .padding()
  }

  var anyView: any View {
    Text("Hello")
  }

  func foo() {
    var aDelegate = delegate
    aDelegate = delegate
    print(aDelegate)
  }

  var delegate: some Delegate {
    MyDelegate()
  }
}

class MyDelegate: Delegate {

}

protocol Delegate {

}

#Preview {
  ContentView()
}
