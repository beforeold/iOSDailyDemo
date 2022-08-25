//
//  MVC.swift
//  TestArch
//
//  Created by 席萍萍Brook.dinglan on 2021/12/29.
//

import Foundation


extension ViewController {
    func mvcDidLoad() {
        mvcTextField.text = model.value
        
        mvcObserver = NotificationCenter.default.addObserver {[weak self] noti in
            self?.mvcTextField?.text = noti.textKeyValue
        }
    }
    
    @IBAction func mvcCommit(_ sender: Any?) {
        model.value = mvcTextField.text ?? ""
    }
}
