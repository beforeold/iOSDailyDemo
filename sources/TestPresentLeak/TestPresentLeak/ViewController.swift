import SwiftUI
import UIKit

class SecondViewController: UIHostingController<AnyView> {
  var close: () -> Void = { }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .gray
  }

  deinit {
    print(#function, self)
  }
}

class FirstViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    let close = {
      print("onclose")

      self.dismiss(animated: true) {
//        self.presentingViewController?.dismiss(animated: true)
      }
    }

    let secondVC = SecondViewController(rootView: AnyView(
      Button("Tap") {
        close()
      }
    ))
    secondVC.close = close
    secondVC.modalPresentationStyle = .fullScreen
    present(secondVC, animated: true)
  }

  deinit {
    print(#function, self)
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let first = FirstViewController()
    first.modalPresentationStyle = .fullScreen
    present(first, animated: true)
  }

}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
