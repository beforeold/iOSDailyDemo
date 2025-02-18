import SwiftUI

struct ContentView: View {
  @State private var id = 0
  var body: some View {
    let _ = print("content body")

    VStack {
      SubView {
        id += 1
      }
      .id(id)
    }
    .padding()
  }
}

struct BackgroundView: View {
  class Object: NSObject {
    static var increment = 0

    var seq = 0

    override init() {
      super.init()

      Object.increment += 1

      self.seq = Object.increment
      print("create", self.seq)
    }

    deinit {
      print("deinit", self.seq)
    }
  }

  class Object2: NSObject, ObservableObject {
    static var increment = 0

    var seq = 0

    override init() {
      super.init()

      Object.increment += 1

      self.seq = Object.increment
      print("create", self.seq)
    }

    deinit {
      print("deinit", self.seq)
    }
  }

//  @State private var object = Object()

  let object = Object()

//  @StateObject private var object2 = Object2()

  var body: some View {
    Text("overlay")
  }
}

struct SubView: View {
  @State private var count = 0
  var action: () -> Void

  var body: some View {
    Button("Click: \(count)") {
      action()

      Task {
//        [value = _count] in
        try await Task.sleep(nanoseconds: 1_000_000_000)
//        value.wrappedValue += 1
        print("updated")
      }
    }
    .background {
      BackgroundView()
    }
  }
}

#Preview {
  ContentView()
}
