//
//  ViewController.swift
//  TestUIStackViwe2
//
//  Created by dinglan on 2021/5/28.
//

import UIKit

class ViewController: UIViewController {

    let stack = UIStackView()
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addLabel)))
        stack.axis = .vertical
        view.backgroundColor = .blue
        scrollView.backgroundColor = .red

        //Add scroll view and setup position
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        //Set maximum height
        scrollView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true

        //add stack
        scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        //setup scrollView content size constraints
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        // Keep short if stack height is lower than scroll height
        // With this constraint the scrollView grows as expected, but doesn't scroll when it goes over 100px
        // Without this constraint the scrollView is always 100px tall but it does scroll
        let constraint = scrollView.heightAnchor.constraint(equalTo: stack.heightAnchor)
        constraint.priority = UILayoutPriority(rawValue: 999)
        constraint.isActive = true

        addLabel()
    }

    @objc func addLabel() {
        let label = UILabel()
        label.backgroundColor = .gray
        label.text = "Hello"
        stack.addArrangedSubview(label)
    }
}
