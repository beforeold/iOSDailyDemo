import SwiftUI

struct ContentView: View {
  @State private var count = 0

  var body: some View {
    VStack(spacing: 30) {
      Button("plus") {
        count += 1
      }

      ValueDontReadView(count: count)
      ValueReadView(count: count)

      BindingDontReadView(count: $count)
      BindingReadView(count: $count)
    }
    .padding()
  }
}

struct ValueDontReadView: View {
  var count: Int

  var body: some View {
    let _ = Self._printChanges()

    Text("hello")
  }
}

struct ValueReadView: View {
  var count: Int

  var body: some View {
    let _ = Self._printChanges()

    Text("hello \(count)")
  }
}

struct BindingReadView: View {
  @Binding var count: Int

  var body: some View {
    let _ = Self._printChanges()

    Text("hello \(count)")
  }
}

struct BindingDontReadView: View {
  @Binding var count: Int

  var body: some View {
    let _ = Self._printChanges()

    Text("hello")
  }
}

class ViewModel: ObservableObject {
  @Published var count = 0

  init(id: String = #function) {
    print("init view model 2", id)
  }
}

struct GlobalModifier: PreviewModifier {
  var name: String
  
  static func makeSharedContext() async throws -> ViewModel {
    print("make shared content")

    let model = ViewModel()
    return model
  }

  func body(content: Content, context: ViewModel) -> some View {
    print("modify by ", name)

    return content
      .environmentObject(context)
  }
}

#Preview(traits: .modifier(GlobalModifier(name: "content"))) {
  ContentView()
}
