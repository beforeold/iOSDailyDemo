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
        
        // centralManager.start()
        peripheralManager.start()
    }
}

