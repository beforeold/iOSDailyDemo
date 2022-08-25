//
//  ViewController.swift
//  TestDistributionDemo
//
//  Created by 席萍萍Brook.dinglan on 2021/11/6.
//

import UIKit
import MYFramework
import SwiftyRSA

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view did load")
        
        let p = PublicFile()
        p.foo()
        
        let person = SwiftRSAPerson(obj: self)
        let proto = BaseProtocol.self
        let subproto = SubProtocol.self
    }


}

