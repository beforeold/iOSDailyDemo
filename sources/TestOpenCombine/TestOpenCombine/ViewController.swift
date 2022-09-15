//
//  ViewController.swift
//  TestOpenCombine
//
//  Created by dinglan on 2021/5/9.
//

import UIKit
import OpenCombine

class ViewController: UIViewController {
    @OpenCombine.Published
    var name: String = "brook"
    
    var bag: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bag = $name.sink {
            print("receive", $0)
        }
        
        print(self.name)
        self.name = "nancy"
        print(self.name)
        
        print($name.subject === $name.subject)
    }


}

