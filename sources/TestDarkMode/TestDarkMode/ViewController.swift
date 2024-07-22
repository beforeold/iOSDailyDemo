import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    print(#function, traitCollection)
  }

  func observerDarkModeChagne() {

  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    print("self", self.traitCollection)

    print("system current", UITraitCollection.current)
  }

  @objc func onChange(arg1: UITraitEnvironment, arg2: UITraitCollection) {
    print(arg1)
    print("")
    print(arg2)
  }

  @objc func darkModeChanged() {

  }

}

