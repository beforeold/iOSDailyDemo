//
//  ViewController.swift
//  TestWindowRootViewControlelrTransition
//
//  Created by Brook_Mobius on 11/2/23.
//

import UIKit

class YourNewViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .green
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let newRootViewController = YourNewViewController()
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

