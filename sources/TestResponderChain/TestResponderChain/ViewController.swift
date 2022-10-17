//
//  ViewController.swift
//  TestResponderChain
//
//  Created by beforeold on 2022/10/17.
//

import UIKit

class MyView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("view touchesBegan")
        super.touchesBegan(touches, with: event)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = MyView(frame: .init(x: 100, y: 100, width: 100, height: 100))
        v1.backgroundColor = .lightGray
        view.addSubview(v1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("controller touchesBegan")
        super.touchesBegan(touches, with: event)
    }
}

