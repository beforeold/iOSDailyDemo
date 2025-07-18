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
      NSLog("Hello world")
      print("Hello world 2")
    }
  }
}

#Preview {
  ContentView()
}
