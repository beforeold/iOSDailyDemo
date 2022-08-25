//
//  ViewController.swift
//  TestUIStackView
//
//  Created by dinglan on 2021/5/27.
//

import UIKit

class ViewController: UIViewController {

    var stack: UIStackView!
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.cyan
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupScrollView()
        
        setupStack()
        
        print("view did load")
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        
        let target = scrollView
        target.translatesAutoresizingMaskIntoConstraints = false
        let container = view!
        
        let leading = target.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        let trailing = target.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        let top = target.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        let height = target.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
        let bottom = target.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(stack as Any)
        scrollView.contentSize = stack.bounds.size
    }
    
    func setupStack() {
        let str = "Do any additional setup after loading the view."
        
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        view.addSubview(stack)
        
        let number = 7
        
        for i in 0..<number {
            let label = UILabel()
            label.numberOfLines = 0
            var text = ""
            
            for _ in 0...i {
                text += str
                text += "\n"
            }
            
            label.text = text
            label.textColor = .lightGray
            
            print(text)
            stack.addArrangedSubview(label)
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let target = stack
        let container = scrollView
        
        let leading = target.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        let trailing = target.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        let top = target.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        let bottom = target.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        let c = target.heightAnchor.constraint(equalTo: container.heightAnchor)
        c.priority = UILayoutPriority(rawValue: 750)
        c.isActive = true
        
        NSLayoutConstraint.activate([leading, trailing, bottom, top])
        
        self.stack = stack
    }


}

