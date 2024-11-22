import SwiftUI

struct ContentView: View {
  @State private var menu = false

  var body: some View {
    Button("ok") {
      menu = true
    }
    .contextMenu {
      Button("ok") {
        print("ok")
      }
    }
  }
}

#Preview {
  ContentView()
}
