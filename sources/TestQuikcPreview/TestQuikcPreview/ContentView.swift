import QuickLook
import SwiftUI

struct ContentView: View {
  @State private var url: URL?

  var body: some View {
    VStack {
      Button("show") {
        url = URL(string: "https://m.media-amazon.com/images/I/71E3aCoLKNL._SL1194_.jpg")
      }
    }
    .padding()
    .quickLookPreview($url)
  }
}

#Preview {
  ContentView()
}
