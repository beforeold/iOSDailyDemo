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
      let task = Task {
        try await Task.sleep(for: .seconds(5))
      }
      try await task.value

      print("sleep end")
    } catch {
      print("sleep", error)
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
