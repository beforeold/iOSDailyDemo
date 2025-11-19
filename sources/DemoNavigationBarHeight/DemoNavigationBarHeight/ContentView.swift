import SwiftUI
import UIKit

/// 你要展示的 UIKit ViewController
final class DemoViewController: UIViewController {
  var button: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = "Demo VC"
    configureRightBarButton()

    let label = UILabel()
    label.text = "Hello from UIViewController"
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  private func configureRightBarButton() {
    let button = UIButton(type: .system)
    // button.setTitle("Tap Me", for: .normal)
    button.setImage(.init(systemName: "gean"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(didTapRightButton(_:)), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    self.button = button
  }

  @objc private func didTapRightButton(_ sender: UIButton) {
    print("Right navigation button tapped: \(sender)")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    print("button frame", button.frame)

    let subviews = navigationController?.navigationBar.subviews[1].subviews.last?.subviews ?? []
    subviews.forEach { print($0) }
  }
}

/// 把 UINavigationController 包成 SwiftUI View
struct NavWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UINavigationController {
    let rootVC = DemoViewController()
    let nav = UINavigationController(rootViewController: rootVC)
    return nav
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    // 这里暂时不需要做更新处理
  }
}

struct ContentView: View {
  var body: some View {
    NavWrapper()
      .ignoresSafeArea()  // 如果你想完整看到导航栏/状态栏区域，可以加上这一句
  }
}

#Preview {
  ContentView()
}
