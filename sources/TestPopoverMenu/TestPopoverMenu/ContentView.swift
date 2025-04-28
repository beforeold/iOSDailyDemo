import SwiftUI

struct DetailView: View {
  var body: some View {
    VStack {
      Text("message")

      Button("Dismiss") {

      }

      Button("OK") {

      }
    }
  }
}

struct ContentView: View {
  @State private var shows = false

  var body: some View {
    VStack {
      Button("show detail") {
        shows = true
      }
    }
    .frame(width: 100, height: 100)
    .background(Color.gray)
    .popover(isPresented: $shows) {
      DetailView()
        .presentationCompactAdaptation(.popover)
        .frame(minWidth: 300, maxHeight: 300)
    }
  }
}

#Preview {
  ContentView()
}
