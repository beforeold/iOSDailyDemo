//
//  ViewController.swift
//  MyLibraryExample
//
//  Created by Brook_Mobius on 8/8/23.
//

import UIKit
import MyLibrary

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    testLib()
  }
  
  private func testLib() {
    let ins = MyLibrary()
    
    print(ins.text)
  }
  
}

