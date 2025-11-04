import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image("pic_avatar_default")
        .frame(width: 100, height: 100)
        .background()
        .environment(\.colorScheme, .light)

      Image("pic_avatar_default")
        .frame(width: 100, height: 100)
        .background()
        .environment(\.colorScheme, .dark)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
