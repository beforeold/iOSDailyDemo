import ffmpegkit
import SwiftUI

func foo() async {
  await withCheckedContinuation { continuation in
    FFmpegKit.executeAsync("command", withCompleteCallback: { session in
      print("state value:", session?.getState().rawValue ?? -1)

      (0...10).forEach { _ in print("\n") }
      continuation.resume()
    })
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .task {
      await foo()
      print("done")
    }
  }
}

#Preview {
  ContentView()
}
