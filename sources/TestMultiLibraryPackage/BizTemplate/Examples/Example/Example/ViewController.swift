import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    setupButton()
  }

  func setupButton() {
    let button = UIButton(
      frame: CGRect(x: 100, y: 100, width: 100, height: 100),
      primaryAction: .init(title: "tap") { [weak self] _ in self?.buttonTapped() }
    )

    self.view.addSubview(button)
  }

  private func buttonTapped() {
    print(#function)
  }
}
