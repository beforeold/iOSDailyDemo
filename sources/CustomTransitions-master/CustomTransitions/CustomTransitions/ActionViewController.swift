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
    
    view.backgroundColor = .yellow
    
    log()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    log()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    log()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    log()
  }
  
  @IBAction func dismiss(sender: UIButton) {
    dismiss(animated: true)
  }
  
  func log(function: String = #function) {
    print(function, view.subviews[0].frame)
  }
}
