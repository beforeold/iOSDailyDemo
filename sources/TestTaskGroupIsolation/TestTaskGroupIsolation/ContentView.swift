import SwiftUI

actor MyActor: Actor {
  static let shared = MyActor()
}

@MainActor
struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      Task {
        print("appear begin")
        await testTaskGroup()
      }
    }
    .task {
      await hello()
      print("isolation", #isolation)

      print("task begin")
      await testTaskGroup()
    }
  }

  nonisolated func hello() async {
    // print("testTaskGroup #isolation", #isolation)
  }

  func testTaskGroup() async {
    await withTaskGroup(of: Void.self, isolation: MyActor.shared) { group in
      print("testTaskGroup #isolation", #isolation)

      for _ in 0..<30 {
        group.addTask {
          // print("testTaskGroup #isolation", #isolation)

          print("hello")
//          await log()
        }
      }
      await group.waitForAll()
    }
  }

  func log() {
    print("log")
  }
}

#Preview {
  ContentView()
}
