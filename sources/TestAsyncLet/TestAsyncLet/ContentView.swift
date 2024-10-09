import SwiftUI

@MainActor
struct ContentView: View {
  var body: some View {
    Button(action: action) {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")

        ProgressView()
      }
    }
    .padding()
    .task {
      // await foo()
      async let value = syncFunc()

      print(await value)
    }
  }

  func action() {
    print(#function)
  }

  func foo() async {
    print("begin")

    async let value = syncFunc()

    print("middle")
    print(await value)
    print("end")
  }
}

func syncFunc() -> Int {
  print("syncFunc begin", Thread.current)

  Thread.sleep(forTimeInterval: 5)

  print("syncFunc end", Thread.current)

  return 5
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
