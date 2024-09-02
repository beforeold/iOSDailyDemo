import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      NavigationLink(
        destination: {
          Text("dest")
        },
        label: {
          VStack {
            Image(systemName: "globe")
              .imageScale(.large)
              .foregroundStyle(.tint)
            Text("Hello, world!")
          }
        }
      )
      .task {
        print("task start")

        do {
          try await Task.sleep(nanoseconds: 5_000_000_000)
          print("task success")
        } catch {
          print("task failed", error)
        }
      }
    }
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
