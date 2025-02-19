import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Button("Open") {
        UIApplication.shared.openURL(
          URL(string: "artguru://")!
        )
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
