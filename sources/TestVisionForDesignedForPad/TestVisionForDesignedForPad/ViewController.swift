//
//  ViewController.swift
//  TestVisionForDesignedForPad
//
//  Created by Brook_Mobius on 7/12/23.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  func foo() {
#if os(xrOS)
    print("yo xi")
#endif
  }
  
}

