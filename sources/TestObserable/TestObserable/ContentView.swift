import ObservationBP
import SwiftUI

@Perceptible
class Model {
  var count = 0
}

struct ContentView: View {
  @State private var count = 0
  @State private var model = Model()
  var model2: Model

  var bodyBP: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  ContentView(model2: .init())
}
