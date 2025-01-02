import SwiftUI

struct ContentView: View {
  @State private var path: [String] = []
  @State private var hasCorner = false

  var body: some View {
    NavigationStack(path: $path) {
      VStack(spacing: 30) {
        Button("Toggle") {
          withAnimation {
            hasCorner.toggle()
          }
        }

        SubView(hasCorner: hasCorner)
      }
      .padding()
    }
  }
}

struct SubView: View {
  var hasCorner: Bool

  var body: some View {
    Text("hi")
      .foregroundColor(.white)
      .frame(width: 100, height: 100)
      .background(Color.blue)
      .cornerRadius(hasCorner ? 20 : 0)
  }
}

#Preview {
  ContentView()
}
