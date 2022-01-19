//
//  ViewController.swift
//  ServiceBridge
//
//  Created by 席萍萍Brook.dinglan on 2021/9/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo()
    }
    
    func demo() {
//        Bridge.shared.brook_fun()
//        let rect = Bridge.shared.nancy_fun()
//        print(rect)
//
        
        let isLogin = Bridge.shared.brook_isLogin()
        print(isLogin)
    }


}

