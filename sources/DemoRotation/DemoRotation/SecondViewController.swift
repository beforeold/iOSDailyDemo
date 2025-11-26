import UIKit

final class SecondViewController: UIViewController {

  private let messageLabel: UILabel = {
    let label = UILabel()
    label.text = "This is the second view controller."
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Second"
    view.backgroundColor = .systemGray6
    setupLayout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    (UIApplication.shared.delegate as? AppDelegate)?.canRotate = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    (UIApplication.shared.delegate as? AppDelegate)?.canRotate = false
  }

//  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//    .all
//  }

  private func setupLayout() {
    view.addSubview(messageLabel)
    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
      messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
    ])
  }
}
