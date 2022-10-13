//
//  ViewController.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/9.
//

import UIKit

class ViewController: UIViewController {
  let centralManager = BTCentralManager()
  
  let peripheralManager = BTPeriperalManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func onWriteClick(_ sender: Any) {
    centralManager.write()
  }
  
  @IBAction func onCentralStart() {
    centralManager.start()
  }
  
  @IBAction func onPeriperalStart() {
    peripheralManager.start()
  }
}

