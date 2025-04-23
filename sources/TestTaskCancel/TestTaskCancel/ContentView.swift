import SwiftUI

// problem: how to make a task uncancellable

struct ContentView: View {
  @State private var task: Task<Void, Error>?

  var body: some View {
    VStack {
      Button("Fire") {
        task = Task {
          try await request2()
        }
        print("reqeust start")
      }

      Button("Cancel") {
        task?.cancel()
      }
    }
    .padding()
  }

  func request() async throws {
    let work = Task(priority: nil) {
      //      do {
      //
      //      } catch {
      //        print("request failed", error)
      //      }
      let _ = try await URLSession.shared.data(
        for: .init(url: .init(string: "https://apple.com/")!)
      )
    }
    let _ = try await work.value

    print("request over")
  }

  func request2() async throws {
    do {
      // try await Task.sleep(for: .seconds(6))
      let _ = try await URLSession.shared.data(
        for: .init(url: .init(string: "https://apple.com/")!)
      )
    } catch {
      print("request failed", error)
      throw error
    }

    print("request over")
  }
}

#Preview {
  ContentView()
}
