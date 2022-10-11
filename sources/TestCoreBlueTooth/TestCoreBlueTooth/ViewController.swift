//
//  ViewController.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/9.
//

import UIKit

class ViewController: UIViewController {
    let manager = BTCentralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.start()
    }

 
}

