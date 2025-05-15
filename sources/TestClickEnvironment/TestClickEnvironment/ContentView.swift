import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")

      SubView()
    }
    .padding()
    .font(.title)
  }
}

struct SubView: View {
  var body: some View {
    Button("Tap") {
      // can not read environment from the action
      @Environment(\.font) var font
      print("font", font ?? "null")
    }

    WithEnvironment { env in
      Button("MyTap") {
        // can not read environment from the action
        print("font", env.font ?? "null")
      }
    }
  }
}

struct WithEnvironment<Content: View>: View {
  @ViewBuilder var content: (EnvironmentValues) -> Content

  @Environment(\.self)
  private var env

  var body: some View {
    content(env)
  }
}

#Preview {
  ContentView()
}
