//
//  ViewController.swift
//  TestLazyPropertyWrapper
//
//  Created by Brook_Mobius on 5/29/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

  @Published lazy var age: Int = 5
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}

