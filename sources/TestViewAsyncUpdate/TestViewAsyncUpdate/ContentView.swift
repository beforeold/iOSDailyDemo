import SwiftUI

struct ContentView: View {
  @State private var id = 0
  var body: some View {
    VStack {
      SubView {
        id += 1
      }
      .id(id)
    }
    .padding()
  }
}

struct BackgroundView: View {
  class Object: NSObject {
    deinit {
      print("deinit")
    }
  }

  @State private var object = Object()

  var body: some View {
    Text("overlay")
  }
}

struct SubView: View {
  @State private var count = 0
  var action: () -> Void

  var body: some View {
    Button("Click: \(count)") {
      action()

      Task {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        count += 1
        print("updated")
      }
    }
    .background {
      BackgroundView()
    }
  }
}

#Preview {
  ContentView()
}
