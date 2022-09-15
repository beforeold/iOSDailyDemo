//
//  MinimalMVVM.swift
//  TestArch
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

class MinimalViewModel: NSObject {
    let model: Model
    var observer: NSObjectProtocol?
    
    @objc dynamic var textValue: String
    
    init(model: Model) {
        self.model = model
        self.textValue = model.value
        super.init()
        
        self.observer = NotificationCenter.default.addObserver(using: {[weak self] noti in
            self?.textValue = noti.textKeyValue
        })
    }
    
    func commit(value: String) {
        model.value = value
    }
}

extension ViewController {
    func minimalMVVMDidLoad() {
        minimalViewModel = MinimalViewModel(model: model)
        minimalObserver = minimalViewModel?.observe(\.textValue, options: [.initial, .new], changeHandler: {[weak self] _, change in
            let newValue = change.newValue
            self?.minimalMVVMTextField.text = newValue ?? ""
        })
    }
    
    @IBAction func minimalMVVMCommit() {
        minimalViewModel?.commit(value: minimalMVVMTextField.text ?? "")
    }
}
