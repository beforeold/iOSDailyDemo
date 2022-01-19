//
//  ViewController.swift
//  TestDemoIOS9
//
//  Created by 席萍萍Brook.dinglan on 2021/11/1.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        showLabel_normal()
        showLabel_html()
    }

    func showLabel_normal() {
        let label = UILabel(frame: .init(x: 20, y: 100, width: 280, height: 200))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "NORMAL:\n message from the ownner of the store, please check it \n\n \(label.font!)"
        label.textColor = .white
        view.addSubview(label)
    }
    
    func showLabel_html() {
        let label = MDHTMLLabel(frame: .init(x: 20, y: 300, width: 280, height: 200))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.htmlText = "<a href=\"HTML:\n message from the ownner of the store, please check it \n\n \(label.font!)\"</a>"
        label.textColor = .white
        view.addSubview(label)
    }

}

