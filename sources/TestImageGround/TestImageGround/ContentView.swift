import ImagePlayground
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
    .imagePlaygroundSheet(
      isPresented: .constant(true),
      concept: "",
      sourceImageURL: URL(string: "https://test.com")!
    ) { url in
      print(url)
    }
  }
}

#Preview {
  ContentView()
}
