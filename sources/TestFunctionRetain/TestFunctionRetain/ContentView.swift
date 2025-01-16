import SwiftUI

class Model {
  func request(block: @escaping () -> Void) {
    let url = URL(string: "https://appe.com")!
    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, resp, error in
      block()
    }
    task.resume()
  }
}

class Manager {
  func foo() {
    let model = Model()
    model.request(block: Manager.bar(self))
     model.request(block: self.bar)
//    model.request(block: bar)
  }

  func bar() {

  }
}

struct ContentView: View {
  @State private var model = Model()

  func foo() {
    print("foo")
  }

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      model.request(block: foo)
    }
  }
}

#Preview {
  ContentView()
}
