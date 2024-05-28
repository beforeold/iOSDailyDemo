//
//  ViewController.swift
//  TestUIBUttonPrimary
//
//  Created by xipingping on 5/28/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.image()
  }

  func image() {
    let button = UIButton(
      configuration: .borderedProminent(),
      primaryAction: UIAction(
        title: "Tap Me",
        image: UIImage(systemName: "clock"),
        handler: { _ in
          print("button tapped")
        }
      )
    )
    button.backgroundColor = .red
    button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    view.addSubview(button)
  }

  func configuration() {
    let button = UIButton(
      configuration: .borderedProminent(),
      primaryAction: UIAction(
        title: "Tap Me",
        handler: { _ in
          print("button tapped")
        }
      )
    )
    button.backgroundColor = .red
    button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    view.addSubview(button)
  }

  func primary() {
    let button = UIButton(
//      frame: .init(x: 0, y: 0, width: 200, height: 50),
      type: .close,
      primaryAction: UIAction(
        title: "",
        handler: { _ in
          print("button tapped")
        }
      )
    )
    button.backgroundColor = .red
    button.center = view.center
    view.addSubview(button)
  }
}

