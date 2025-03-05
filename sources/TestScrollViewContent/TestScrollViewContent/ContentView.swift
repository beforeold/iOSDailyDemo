import SwiftUI

struct ContentView: View {
  var body: some View {
    ScrollView {
      VStack {
        ForEach(0..<100) {
          Text("\($0)")
            .frame(height: 66)
        }
      }
      .frame(width: UIScreen.main.bounds.width)
    }
  }
}

#Preview {
  ContentView()
}
