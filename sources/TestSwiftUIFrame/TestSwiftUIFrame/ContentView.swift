import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Color.blue
        .frame(width: 100, height: 100)
        .frame(width: 20, height: 20)
        .clipped()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
