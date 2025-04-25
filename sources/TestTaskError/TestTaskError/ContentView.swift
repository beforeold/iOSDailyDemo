import SwiftUI

func foo() async throws {
  print("hello")
}

struct ContentView: View {
  var body: some View {
    Button("Tap me") {
      Task {
        try await foo()
      }
    }

    Button("Tap me") {
      let task = Task<_, Never> {
        do {
          try await foo()
        } catch {
          print("failed", error)
        }
      }
      print(task)
    }
  }
}

#Preview {
  ContentView()
}
