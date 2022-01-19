//
//  ViewController.swift
//  TestMVI
//
//  Created by 席萍萍Brook.dinglan on 2021/12/30.
//

import Foundation

protocol Stateful: AnyObject {
    func updateState(_ state: State)
}

class ViewController {
    class UILabel {
        var text: String?
    }
    
    var textLabel = UILabel()
    var intent = Intent()
    
    func viewDidLoad() {
        intent.bind(to: self)
    }

    @IBAction
    func onNextClick(_ sender: Any?) {
        intent.onNext()
    }
}

extension ViewController: Stateful {
    func updateState(_ state: State) {
        textLabel.text = state.employee[state.index].name
    }
}
