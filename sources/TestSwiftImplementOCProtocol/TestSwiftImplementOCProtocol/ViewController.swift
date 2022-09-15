//
//  ViewController.swift
//  TestSwiftImplementOCProtocol
//
//  Created by 席萍萍Brook.dinglan on 2021/11/4.
//

import UIKit

class SwiftController: NSObject, OCProtocol {
    var name: String?
    required init(name: String) {
        self.name = name
    }
    
    
    func foo() {
        print("controller print foo")
    }
}








class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SomeManager.run()
        
        
    }
}

