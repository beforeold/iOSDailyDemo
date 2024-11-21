import SwiftUI

class Manager: ObservableObject {
  @Published var outer: Bool = false
}

struct ContentView: View {
  @StateObject private var manager: Manager = .init()

  @State private var inner: Bool = false

  var body: some View {
    VStack {
      Button("show innter") {
        inner = true
      }
      .fullScreenCover(isPresented: $inner) {
        InnerView(manager: manager)
      }
    }
    .padding()
    .fullScreenCover(isPresented: $manager.outer) {
      OuterView(manager: manager)
    }
  }
}

struct InnerView: View {
  @Environment(\.dismiss) var dismiss

  @ObservedObject var manager: Manager

  var body: some View {
    VStack(spacing: 30) {
      Button("show outer") {
        manager.outer = true
      }

      Button("dismiss self") {
        dismiss()
      }
    }
  }
}

struct OuterView: View {
  @ObservedObject var manager: Manager

  var body: some View {
    Button("i am outer") {
      manager.outer = true
    }

  }
}

#Preview {
  ContentView()
}
