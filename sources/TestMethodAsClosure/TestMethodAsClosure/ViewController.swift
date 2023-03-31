//
//  ViewController.swift
//  TestMethodAsClosure
//
//  Created by Brook_Mobius on 2023/3/31.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .blue
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let vc = SecondViewController()
    present(vc, animated: true)
  }
 
  
}

