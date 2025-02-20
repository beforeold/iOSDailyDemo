import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Text("Hello, world!")
      Text("__Hello, world!__")
      Text("__Hello__" as String)
      Text(verbatim: "__Hello__")

      VStack {
          Text("This is regular text.")
          Text("* This is **bold** text, this is *italic* text, and this is ***bold, italic*** text.")
          Text("~~A strikethrough example~~")
          Text("`Monospaced works too`")
          Text("Visit Apple: [click here](https://apple.com)")
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
