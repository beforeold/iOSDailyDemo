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
      let defaults = UserDefaults(suiteName: "test2")
      defaults?.set("ok", forKey: "test_key")
      defaults?.set(666, forKey: "second_key")
      // print(defaults?.dictionaryRepresentation() ?? "null")
      print(UserDefaults.standard.dictionaryRepresentation())
    }
  }
}

#Preview {
  ContentView()
}
