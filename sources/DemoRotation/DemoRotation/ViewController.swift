import UIKit

class ViewController: UIViewController {

  private let infoLabel: UILabel = {
    let label = UILabel()
    label.text = "当前朝向：未设置"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let rotateButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("切换到 Landscape Left", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let pushButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Push Second View", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Demo Rotation"

    view.backgroundColor = .systemBackground
    setupLayout()
    rotateButton.addTarget(self, action: #selector(rotateToLandscapeLeft), for: .touchUpInside)
    pushButton.addTarget(self, action: #selector(pushSecondViewController), for: .touchUpInside)
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    updateLabelForCurrentOrientation()

//    navigationController?.delegate = self
  }

  deinit {
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
  }

  private func setupLayout() {
    view.addSubview(infoLabel)
    view.addSubview(rotateButton)
    view.addSubview(pushButton)

    NSLayoutConstraint.activate([
      infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),

      rotateButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24),
      rotateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      pushButton.topAnchor.constraint(equalTo: rotateButton.bottomAnchor, constant: 16),
      pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  @objc
  private func rotateToLandscapeLeft() {
    guard supportedInterfaceOrientations.contains(.landscapeLeft) else {
      infoLabel.text = "当前页面仅支持竖屏"
      return
    }

    guard let windowScene = view.window?.windowScene else {
      infoLabel.text = "当前朝向：无法获取 windowScene"
      return
    }

    if #available(iOS 16.0, *) {
      let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeLeft)
      windowScene.requestGeometryUpdate(preferences) { [weak self] error in
        DispatchQueue.main.async {
          self?.infoLabel.text = "旋转失败：\(error.localizedDescription)"
        }
      }
    } else {
      // Fallback for older iOS versions.
      let orientationValue = UIInterfaceOrientation.landscapeLeft.rawValue
      UIDevice.current.setValue(orientationValue, forKey: "orientation")
      UIViewController.attemptRotationToDeviceOrientation()
      updateLabelForCurrentOrientation()
    }
  }

  @objc
  private func handleOrientationChange() {
    updateLabelForCurrentOrientation()
  }

  @objc
  private func pushSecondViewController() {
    let controller = SecondViewController()
    navigationController?.pushViewController(controller, animated: true)
  }

  private func updateLabelForCurrentOrientation() {
    let description: String
    if let interfaceOrientation = view.window?.windowScene?.interfaceOrientation {
      description = interfaceOrientationDescription(for: interfaceOrientation)
      print("Interface orientation changed: \(description) (\(interfaceOrientation.rawValue))")
    } else {
      let deviceOrientation = UIDevice.current.orientation
      description = deviceOrientationDescription(for: deviceOrientation)
      print("Device orientation changed: \(description) (\(deviceOrientation.rawValue))")
    }
    infoLabel.text = "当前朝向：\(description)"
  }

  private func deviceOrientationDescription(for orientation: UIDeviceOrientation) -> String {
    switch orientation {
    case .portrait: return "Portrait"
    case .portraitUpsideDown: return "Portrait Upside Down"
    case .landscapeLeft: return "Landscape Left"
    case .landscapeRight: return "Landscape Right"
    case .faceUp: return "Face Up"
    case .faceDown: return "Face Down"
    default: return "Unknown"
    }
  }

  private func interfaceOrientationDescription(for orientation: UIInterfaceOrientation) -> String {
    switch orientation {
    case .portrait: return "Portrait"
    case .portraitUpsideDown: return "Portrait Upside Down"
    case .landscapeLeft: return "Landscape Left"
    case .landscapeRight: return "Landscape Right"
    default: return "Unknown"
    }
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    print(#function, size)

    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: nil) { [weak self] _ in
      self?.updateLabelForCurrentOrientation()
    }
  }

//  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//    return .portrait
//  }

}

extension ViewController: UINavigationControllerDelegate {
  func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
    navigationController.topViewController?.supportedInterfaceOrientations ?? .all
  }
}
