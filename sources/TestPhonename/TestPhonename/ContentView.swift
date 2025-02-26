import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Text("name: \(UIDevice.current.name)")
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
