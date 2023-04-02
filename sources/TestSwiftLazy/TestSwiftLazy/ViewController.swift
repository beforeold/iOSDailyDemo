//
//  ViewController.swift
//  TestSwiftLazy
//
//  Created by Brook_Mobius on 2023/4/2.
//

import UIKit

class ViewController: UIViewController {
  lazy var tap01: UITapGestureRecognizer = {
    let tap = UITapGestureRecognizer()
    
    tap.addTarget(self, action: #selector(onTapEvent01))
    
    return tap
  }()
  
  /*
  let tap: UITapGestureRecognizer = {
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTapEvent))
    return tap
  }()
  */
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    view.backgroundColor = .lightGray
    
    view.addGestureRecognizer(tap01)
  }

  // MARK: - events
  @objc func onTapEvent01() {
    print(#function)
  }

  
  @objc func onTapEvent() {
    print(#function)
  }
  
  
}

