//
//  NextVC.swift
//  TestDelayWeakVar
//
//  Created by Brook_Mobius on 10/25/23.
//

import UIKit

class NextVC: UIViewController {
  let action: () -> Void

  init(action: @escaping () -> Void) {
    self.action = action
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .gray

    let button = UIButton()
    button.addTarget(
      self,
      action: #selector(onButtonEvent),
      for: .touchUpInside
    )
    button.frame = .init(x: 100, y: 100, width: 150, height: 100)
    button.setTitleColor(.blue, for: .normal)
    button.setTitle("Tap to Dimiss", for: .normal)
    view.addSubview(button)
  }

  @objc private func onButtonEvent() {
    self.action()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print(#function, self)
  }
}
