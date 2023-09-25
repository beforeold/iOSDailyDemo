//
//  ViewController.swift
//  TestOptionalAsBox
//
//  Created by Brook_Mobius on 9/25/23.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    debugPrint(#function, self)

    let vc = AnotherVC()
    var box: UIViewController?

    vc.onTapCallback = {
      box.pop()?.dismiss(animated: true)
    }
    box = vc

    debugPrint("vc will ViewDidLoad")
    debugPrint("frame", vc.view!.frame)
  }
}

extension Optional {
  mutating func pop() -> Self {
    let value = self
    self = nil
    return value
  }
}


class AnotherVC: UIViewController {
  var onTapCallback: () -> Void = { }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .lightGray

    debugPrint(#function, self)

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      debugPrint("will onTapCallback")
      self?.onTapCallback()
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    debugPrint(#function, self)

    onTapCallback()
  }

  deinit {
    debugPrint(#function, self)
  }
}
