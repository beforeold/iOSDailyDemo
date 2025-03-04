import SwiftUI

class MyViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .blue
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    print(view.bounds, UIScreen.main.bounds)
  }
}

struct ContentView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    let vc = MyViewController()
    let nav = UINavigationController(rootViewController: vc)
    return nav
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    print(uiViewController)
  }
}

#Preview {
  ContentView()
    .ignoresSafeArea()
}
