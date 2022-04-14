//
//  ViewController.swift
//  TestDisplayLink
//
//  Created by BrookXy on 2022/4/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        scrollView.contentSize = .init(width: view.bounds.width, height: 100_000)
        scrollView.backgroundColor = .lightGray
        
        
        let link = CADisplayLink(target: self, selector: #selector(onLinkTick(_:)))
        link.add(to: .main, forMode: .default)
    }
    
    @objc func onLinkTick(_ sender: CADisplayLink) {
        print("tick \(sender.timestamp)")
    }
}

