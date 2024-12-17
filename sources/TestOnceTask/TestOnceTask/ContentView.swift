import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")
        NavigationLink("Next") {
          NextView()
        }
      }
      .padding()
      .onceTask {
        await sleep()
      }
    }
  }

  func sleep() async {
    do {
      print("sleep begin")
      defer { print("inner sleep end") }

      print(Task.isCancelled)

      try await Task.sleep(for: .seconds(5))
    } catch is CancellationError {
      print("Cancelled during inner task")
    } catch {
      print("Error during inner task: \(error)")
    }
  }
}

struct NextView: View {
  var body: some View {
    Text("Next")
  }
}

#Preview {
  ContentView()
}
