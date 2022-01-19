//
//  MVP.swift
//  TestArch
//
//  Created by 席萍萍Brook.dinglan on 2021/12/29.
//

import Foundation


protocol ViewProtocol: AnyObject {
    var text: String { get set }
}

class ViewPresenter {
    weak var view: ViewProtocol?
    let model: Model
    
    var observer: NSObjectProtocol?
    
    init(model: Model, view: ViewProtocol) {
        self.model = model
        self.view = view
        
        self.view?.text = model.value
        
        self.observer = NotificationCenter.default.addObserver {[weak self] noti in
            self?.view?.text = noti.textKeyValue
        }
    }
    
    func commit() {
        model.value = view?.text ?? ""
    }
}

extension ViewController: ViewProtocol {
    var text: String {
        get {
            return mvpTextField.text ?? ""
        }
        
        set {
            mvpTextField.text = newValue
        }
    }
    
    func mvpDidLoad() {
        presenter = ViewPresenter(model: model, view: self)
    }
    
    @IBAction func mvvmCommit(_ sender: Any?) {
        presenter?.commit()
    }
}
