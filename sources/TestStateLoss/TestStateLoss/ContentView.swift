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
  }
}

struct StateLossScroll: View {
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(0..<100) { i in
          RootView(i: i)
        }
      }
    }
  }
}

struct StateLossList: View {
  var body: some View {
    List {
      ForEach(0..<100) { i in
        RootView(i: i)
      }
    }
  }
}

struct RootView: View {
  @State var topState = false
  let i: Int
  var body: some View {
    VStack {
      Text("\(i)")
      Toggle("Top State", isOn: $topState)
      ChildView()
    }
  }
}

struct ChildView: View {
  @State var childState = false
  var body: some View {
    VStack {
      Toggle("Child State", isOn: $childState)
    }
  }
}

#Preview {
  StateLossList()
}

#Preview {
  StateLossScroll()
}

