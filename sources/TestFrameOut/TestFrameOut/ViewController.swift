//
//  ViewController.swift
//  TestFrameOut
//
//  Created by xipingping on 6/28/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

//    let content = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//    content.backgroundColor = .red
//    view.addSubview(content)
//
//    let outofframeView = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
//    outofframeView.backgroundColor = .blue
//    content.addSubview(outofframeView)

    let content = UIView()
    content.translatesAutoresizingMaskIntoConstraints = false
    content.backgroundColor = .red
    view.addSubview(content)

    NSLayoutConstraint.activate([
        content.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        content.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        content.widthAnchor.constraint(equalToConstant: 100),
        content.heightAnchor.constraint(equalToConstant: 100)
    ])

    let outofframeView = UIView()
    outofframeView.translatesAutoresizingMaskIntoConstraints = false
    outofframeView.backgroundColor = .blue
    content.addSubview(outofframeView)

    NSLayoutConstraint.activate([
        outofframeView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 100),
        outofframeView.topAnchor.constraint(equalTo: content.topAnchor, constant: 100),
        outofframeView.widthAnchor.constraint(equalToConstant: 50),
        outofframeView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
}

#Preview {
  ViewController()
}
