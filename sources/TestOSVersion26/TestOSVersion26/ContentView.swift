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
      let os = UIDevice.current.systemVersion
      print(os)
    }
  }
}

#Preview {
  ContentView()
}
