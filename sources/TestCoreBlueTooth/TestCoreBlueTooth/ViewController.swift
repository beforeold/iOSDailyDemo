//
//  ViewController.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/9.
//

import UIKit

class ViewController: UIViewController {
    let manager = BTManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.start()
    }

 
}

