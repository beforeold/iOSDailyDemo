import SwiftUI

public struct Reloader: Hashable {
  private var id: Int = 0

  public init() { }

  public mutating func reload() {
    id &+= 1
  }
}

struct ContentView: View {
  @State private var count = 0

  @State private var reloader = Reloader()

  var body: some View {
    let _ = Self._printChanges()

    VStack {
      Button("reload") {
        reloader.reload()
      }

      Text("count; \(count)")
    }
    // .id(reloader)
    .onChange(of: reloader) { _ in
      count += 1
    }
  }
}

#Preview {
  ContentView()
}
