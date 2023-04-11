//
//  ViewController.swift
//  TestATT
//
//  Created by Brook_Mobius on 2023/4/11.
//

import UIKit
import AppTrackingTransparency

class ViewController: UIViewController {
  
  var button: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    button = UIButton(type: .custom)
    button.frame = .init(x: 100, y: 100, width: 200, height: 100)
    button.setTitleColor(.blue, for: .normal)
    button.setTitle("Click to request", for: .normal)
    button.titleLabel?.numberOfLines = 0
    button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    view.addSubview(button)
  }
  
  @objc func onClick() {
    ATTrackingManager.requestTrackingAuthorization { status in
      print(#function, "staus", status.rawValue)
      DispatchQueue.main.async {
        self.button.setTitle("Click to request, ret \(status.rawValue)", for: .normal)
      }
    }
  }
  
}

