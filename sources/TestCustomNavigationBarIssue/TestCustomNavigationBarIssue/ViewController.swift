import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let subView = UIView(
      frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
    )
    subView.backgroundColor = .blue
    subView.backgroundColor = .red
    view.addSubview(subView)

    let button = UIButton(frame: CGRect(x: 44, y: 44, width: 50, height: 50))
    button.backgroundColor = .green
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    subView.addSubview(button)
  }

  @objc func buttonTapped() {
    print(#function)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
}

