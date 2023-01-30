//
//  ActionViewController.swift
//  CustomTransitions
//
//  Created by Joyce Echessa on 3/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.view.subviews.forEach {
//      ($0 as? UIImageView)?.removeFromSuperview()
//    }
    
    view.backgroundColor = .yellow
    
    print("viewDidLoad", view.subviews)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    print("viewDidLayoutSubviews", view.subviews)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    print("viewWillDisappear", view.subviews)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    print("viewDidDisappear", view.subviews)
  }
  
  @IBAction func dismiss(sender: UIButton) {
    dismiss(animated: true)
  }
  
}
