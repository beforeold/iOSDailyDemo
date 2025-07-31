import SwiftUI

struct ContentView: View {
  var body: some View {
    HStack {
      Line(
        width: 28,
        height: 2
      )

      Spacer().frame(width: 20)

      Line(
        width: .infinity,
        height: 2
      )
    }
    .onAppear {
      print("did appear")
    }

  }
}

struct Line_Previews: PreviewProvider {
  static var previews: some View {
    Line(
      width: .infinity,
      height: 16
    )
  }
}
