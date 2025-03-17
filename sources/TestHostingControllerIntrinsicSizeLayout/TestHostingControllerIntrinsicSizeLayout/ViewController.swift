import SwiftUI
import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let host = UIHostingController(rootView: SomeView())
    host.sizingOptions = .intrinsicContentSize
    addChild(host)
    host.view.backgroundColor = .blue
    view.addSubview(host.view)
    host.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      host.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      host.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

}

struct SomeView: View {
  var body: some View {
    VStack(spacing: 30) {
      Text("hello world")

      Button("Tap") {

      }
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
