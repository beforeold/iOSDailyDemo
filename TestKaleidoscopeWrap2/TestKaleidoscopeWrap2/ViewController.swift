//
//  ViewController.swift
//  TestKaleidoscopeWrap2
//
//  Created by BrookXy on 2022/2/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        test(useUIKit: true)
        
        print()
        
        test(useUIKit: false)
    }
    
    func test(useUIKit: Bool) {
        KSTextField.enableUIKIt = useUIKit
        let textField = KSTextField()
        print(textField)
        print(textField.borderRect(forBounds: .zero))
    }
}

