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
        // manager.outer = true
        print("show outer")

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
          print("no window scenee")
          return
        }

        guard let controller = windowScene.windows.first?.rootViewController else {
          print("no controller")
          return
        }

        print("get root controller", controller)

        controller.present(RedViewController(), animated: true)
      }

      Button("dismiss self") {
        dismiss()
      }
    }
  }
}

class RedViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red
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
