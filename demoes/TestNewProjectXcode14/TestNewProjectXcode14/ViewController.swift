//
//  ViewController.swift
//  TestNewProjectXcode14
//
//  Created by Brook16 on 2022/6/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @dynamicCallable
    struct Brook {
        func dynamicallyCall(withKeywordArguments: KeyValuePairs<String, Any>) {
            
        }
    }
    
    class Lazada {
        func foo() {
            let brook = Brook()
            brook("ok")
        }
    }

}

