//
//  main.swift
//  TestMVI
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

func mock() {
    let vc = ViewController()
    vc.viewDidLoad()
    print(vc.textLabel.text == "Brook")
    
    vc.onNextClick(nil)
    print(vc.textLabel.text == "Nancy")
    
    vc.onNextClick(nil)
    print(vc.textLabel.text == "Sarah")
    
    vc.onNextClick(nil)
    print(vc.textLabel.text == "Brook")
}

mock()
