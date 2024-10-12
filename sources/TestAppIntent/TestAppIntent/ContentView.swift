import SwiftUI

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
      let obj = MyApp()
      obj.$object.wrappedValue = .shared
      obj.foo()
    }
  }
}

typealias Dependency = AppDependency

#Preview {
  ContentView()
}

import AppIntents

class Object {
  static let shared: Object = .init()
}

struct MyApp {
  @Dependency var object: Object

  func foo() {
    print(#function, self.object)
  }
}
