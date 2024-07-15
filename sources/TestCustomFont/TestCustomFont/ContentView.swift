import SwiftUI

struct ContentView: View {

  var body: some View {
    Text("Hello")
      .font(.custom("Montserrat", size: 24).weight(.bold))
//      .font(.system(size: 24).weight(.bold))
      .onAppear {
        printFont()
      }
  }

  private func printFont() {
    let font = UIFont(name: "Montserrat", size: 24)?.description ?? "null"
//    let font = UIFont.systemFont(ofSize: 24)
    print(font)
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
