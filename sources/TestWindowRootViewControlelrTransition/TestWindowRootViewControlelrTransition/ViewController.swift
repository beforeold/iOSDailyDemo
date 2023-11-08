//
//  ViewController.swift
//  TestWindowRootViewControlelrTransition
//
//  Created by Brook_Mobius on 11/2/23.
//

import UIKit

class PresentedViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red

    let button = UIButton(frame: .init(x: 100, y: 100, width: 200, height: 100))
    button.backgroundColor = .blue
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    view.addSubview(button)
  }

  @objc func onTap() {
    print(#function, self)

    dismiss(animated: true)
  }
}

class NewViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .purple
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .green

    let button = UIButton(frame: .init(x: 100, y: 100, width: 200, height: 100))
    button.backgroundColor = .blue
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    view.addSubview(button)
  }

  @objc func onTap() {
    print(#function, self)

    let presented = PresentedViewController()
    presented.modalPresentationStyle = .fullScreen
    present(presented, animated: true) {
      let window = UIApplication.shared.windows.first { $0.isKeyWindow }
      window?.rootViewController = NewViewController()
    }
  }

  /// 测试重新设置 root vc
  func testResetRoot() {
    let newRootViewController = PresentedViewController()
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }

    if let window = window {
      UIView.transition(
        with: window,
        duration: 0.3,
        options: .curveEaseInOut,
        animations: {
          window.rootViewController = newRootViewController
        },
        completion: nil
      )
    }
  }
}

