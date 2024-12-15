import SwiftUI

struct ContentView: View {
  var name: String?

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      name.map {
        Text("name: \($0)")
          .font(.title)
      }
    }
    .padding()
  }
}

#Preview {
  HStack {
    ContentView(name: "br")

    ContentView(name: nil)
  }
}
