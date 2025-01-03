import SwiftUI

struct WrapperWithController<Content: View>: UIViewControllerRepresentable {
  @ViewBuilder var content: () -> Content

  func makeUIViewController(context: Context) -> UIHostingController<Content> {
    UIHostingController(rootView: content())
  }

  func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
    uiViewController.rootView = content()
  }
}

struct WrapperWithView<Content: View>: UIViewRepresentable {
  class Coordinator {
    var controller: UIHostingController<Content>?
  }

  @ViewBuilder var content: () -> Content

  func makeCoordinator() -> Coordinator {
    print(#function)
    return Coordinator()
  }

  func makeUIView(context: Context) -> UIView {
    print(#function)
    let uiView = UIView()
    let controller = UIHostingController(rootView: content())
    controller.view.backgroundColor = .clear
    uiView.addSubview(controller.view)

    controller.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      controller.view.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
      controller.view.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
    ])

    context.coordinator.controller = controller

    return uiView
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    print(#function)
    context.coordinator.controller?.rootView = content()
  }
}

struct ContentView: View {
  @State private var count = 0

  var body: some View {
    VStack {
      WrapperWithView {
        VStack(spacing: 30) {
          ProgressView()

          Text("count: \(count)")
            .frame(width: 150)
        }
      }
      .frame(width: 150, height: 150)
      .background(Color.gray)
      .onTapGesture {
        count += 1
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
