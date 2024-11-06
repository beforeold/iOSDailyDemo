import SwiftUI
import PreviewLib

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .onTapGesture {
      print("on tap")
    }
    .padding()
    .onAppear(perform: {
      Worker.foo()
    })
  }
}

#Preview {
  ContentView()
}
