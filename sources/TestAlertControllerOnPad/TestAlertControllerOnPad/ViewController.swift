import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // 创建按钮
    let button = UIButton(type: .system)
    button.setTitle("Show Alert", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

    view.addSubview(button)

    // 约束放在中间
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  @objc private func showAlert(_ sender: UIButton) {
    let alert = UIAlertController(
      title: "Hello",
      message: "This is an alert controller",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "OK", style: .default))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    // ⚠️ iPad 上必须指定 popover 的锚点（只在 .actionSheet 样式需要）
//    if let popover = alert.popoverPresentationController {
//      popover.sourceView = sender
//      popover.sourceRect = sender.bounds
//    }

    present(alert, animated: true)
  }
}
