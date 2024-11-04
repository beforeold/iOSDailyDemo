import Combine
import SwiftUI

extension ViewModel: ObservableObject {
//  var objectWillChange: ObservableObjectPublisher = .init()
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
  }
}

#Preview {
  ContentView()
}
