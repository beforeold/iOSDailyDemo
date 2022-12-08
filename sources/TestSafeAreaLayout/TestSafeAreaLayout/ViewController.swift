//
//  ViewController.swift
//  TestSafeAreaLayout
//
//  Created by Brook_Mobius on 2022/12/8.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let sub = UIView()
    sub.backgroundColor = .yellow
    
    view.addSubview(sub)
    
    sub.snp.makeConstraints { make in
      make.leading.equalTo(10)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.width.height.equalTo(100)
    }
    
    self.title = "Hello"
  }
  
  
}

