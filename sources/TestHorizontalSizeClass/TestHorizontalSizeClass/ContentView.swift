import SwiftUI

struct ContentView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  var body: some View {
    Text(horizontalSizeClass == .compact ? "Landscape" : "Portrait")
      .onChange(of: horizontalSizeClass) { oldValue, newValue in
        print("new value", newValue ?? "null", UIScreen.main.bounds)
      }
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
        print("new value", UIDevice.current.orientation.rawValue, UIScreen.main.bounds)
        DispatchQueue.main.async {
          print("async new value", UIDevice.current.orientation.rawValue, UIScreen.main.bounds)
        }
      }
  }
}

#Preview {
  ContentView()
}
