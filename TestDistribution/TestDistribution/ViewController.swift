//
//  ViewController.swift
//  TestDistribution
//
//  Created by 席萍萍Brook.dinglan on 2021/11/6.
//

import UIKit
import MYFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view did load")
        
        let p = PublicFile()
        p.foo()
    }


}

