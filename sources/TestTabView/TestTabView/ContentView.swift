import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      Text("Hello")
        .tabItem {
          Label("Hello", systemImage: "gear")
        }

      Text("world")
        .tabItem {
          Label("World", systemImage: "photo")
        }
    }
  }
}

#Preview {
  ContentView()
}
