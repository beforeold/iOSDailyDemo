//
//  ViewController.swift
//  Demo
//
//  Created by beforeold on 2022/10/19.
//

import UIKit

extension UIView {
    func findView<T: UIView>(of type: T.Type, ret: inout [T]) {
        if let self = self as? T {
            ret.append(self)
        }
        self.subviews.forEach { sub in
            sub.findView(of: type, ret: &ret)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ret = [UITextView]()
        self.view.findView(of: UITextView.self, ret: &ret)
        assert(ret.map { $0.text ?? "null"} == ["first", "second"])
    }
}

