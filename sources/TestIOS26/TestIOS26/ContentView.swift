import SwiftUI


func iOS26() -> Bool {
  if #available(iOS 19.0, *) {
    return true
  }
  return false
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
    .onAppear {
      print(
        "iOS26: ",
        iOS26(),
        UIDevice.current.systemVersion
      )
    }
  }
}

#Preview {
  ContentView()
}
