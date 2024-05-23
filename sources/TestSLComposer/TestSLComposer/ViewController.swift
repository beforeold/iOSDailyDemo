//
//  ViewController.swift
//  TestSLComposer
//
//  Created by Brook_Mobius on 1/11/24.
//

import UIKit
import Social

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    print(#function)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    showComposer()
  }

  private func showComposer() {
    guard let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook) else {
      return
    }

    controller.setInitialText("#picaai")
    controller.add(UIImage(named: "222"))
    // controller.add(URL(string: "https://apps.apple.com/app/id6446337794"))

    self.present(
      controller,
      animated: true
    )
  }


}

