import SwiftUI
import MyApp

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
      Person().foo()
    }
  }
}

#Preview {
  ContentView()
}
