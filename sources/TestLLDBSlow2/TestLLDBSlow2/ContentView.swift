import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      let string = "Hello"
      let object = NSObject()
      print(string, object)
    }
  }
}

#Preview {
  ContentView()
}
