import SwiftUI

struct ContentView: View {
  @State private var count = 0
  var body: some View {
    VStack {
      Button("Plus") {
        count += 1
      }

      SubView(count: count) {
        print("on lick")
      }
    }
    .padding()
  }
}

class Object: NSObject {
  var onClick: () -> Void = {}

  override init() {
    super.init()

    print("init \(self)")
  }

  deinit {
    print("deinit", self)
  }
}

struct SubView: View {
  @State private var object = Object()
  var count: Int

  init(count: Int, onClick: @escaping () -> Void) {
    self.count = count
    self.object.onClick = onClick
    print("init view", self.object)
  }

  var body: some View {
    let _ = dump(self._object)

    VStack {
      Text("object: \(object)")
      Text("count: \(count)")
    }
    .foregroundStyle(.yellow)
  }
}

#Preview {
  ContentView()
}
