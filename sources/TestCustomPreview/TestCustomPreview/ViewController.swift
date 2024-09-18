import UIKit

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let button = UIButton(type: .system)
    button.setTitle("Tap me", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    let interaction = UIContextMenuInteraction(delegate: self)
    button.addInteraction(interaction)
  }
}

extension ViewController: UIContextMenuInteractionDelegate {

  func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    print(#function)
    return UIContextMenuConfiguration(identifier: "12" as NSString, previewProvider: { [weak self] in
      guard let self = self else { return nil }
      print(self)

      let previewViewController = UIViewController()
      previewViewController.view = UIView()
      previewViewController.view.backgroundColor = .white

      if let button = interaction.view as? UIButton {
        let buttonSnapshot = button.snapshotView(afterScreenUpdates: false)
        buttonSnapshot?.frame = CGRect(x: 50, y: 50, width: button.frame.width, height: button.frame.height)
        previewViewController.view.addSubview(buttonSnapshot!)
      }

      let blueRectangle = BlueRectangleView(frame: CGRect(x: 50, y: 150, width: 100, height: 100))
      previewViewController.view.addSubview(blueRectangle)

      return previewViewController
    }, actionProvider: { _ in
      return UIMenu(title: "hello", children: [])
    })
  }
}

import UIKit

class BlueRectangleView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = .blue
  }
}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
