import SwiftUI

struct ContentView: View {
  var body: some View {
    ViewThatFits(in: .horizontal) {
      HStack {
        Text("Title")
        Text("Optional")
        Spacer()
        Image(systemName: "chevron.right")
      }

      HStack {
        Text("Title")
        Spacer()
        Image(systemName: "chevron.right")
      }
    }
  }
}

#Preview {
  VStack(alignment: .leading) {
    ContentView()
      .frame(width: 100)

    ContentView()
      .frame(width: 200)
  }
}
