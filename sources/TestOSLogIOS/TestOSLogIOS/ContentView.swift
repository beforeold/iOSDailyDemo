import SwiftUI
import os

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
      let logger = Logger(subsystem: "com.test.app", category: "home")
      logger.log(level: .error, "error")
      do {
        let logger = Logger(subsystem: "com.test.app", category: "me")
        logger.log(level: .error, "me appear")
      }
//      print("on appear")
    }
  }
}

#Preview {
  ContentView()
}
