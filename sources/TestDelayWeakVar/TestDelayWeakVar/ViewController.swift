//
//  ViewController.swift
//  TestDelayWeakVar
//
//  Created by Brook_Mobius on 10/25/23.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .green

    let button = UIButton()
    button.addTarget(
      self,
      action: #selector(onButtonEvent),
      for: .touchUpInside
    )
    button.frame = .init(x: 100, y: 100, width: 150, height: 100)
    button.setTitleColor(.blue, for: .normal)
    button.setTitle("Tap to Show", for: .normal)
    view.addSubview(button)
  }

  @objc private func onButtonEvent() {
    weak var weakNext: NextVC?
    let next = NextVC {
      print("on action")
      weakNext?.dismiss(animated: true)
    }
    weakNext = next

    present(next, animated: true)
  }


}

