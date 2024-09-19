import SwiftUI

// import BizTemplate

func foo() {
  // File.hello()
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
    .onAppear {
      foo()
    }
  }
}

#Preview {
  ContentView()
}
