//
//  ViewController.swift
//  TestSPMModulize
//
//  Created by Brook_Mobius on 8/8/23.
//

import UIKit
import MyLibrary

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let lib = MyLibrary()
    print(lib.text)
  }


}

