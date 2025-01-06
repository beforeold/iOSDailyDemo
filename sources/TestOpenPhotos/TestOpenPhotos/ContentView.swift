import SwiftUI

struct ContentView: View {
  @Environment(\.openURL) private var openURL

  var body: some View {
    Button("Open Photos") {
      openURL(URL(string: "photos-redirect://")!)
    }
  }
}

#Preview {
  ContentView()
}
