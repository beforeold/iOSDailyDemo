//
//  ViewController.swift
//  TestModalTransition
//
//  Created by Brook_Mobius on 2023/3/23.
//

import UIKit



class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .lightGray
    
    // Create buttons and set actions
    let button1 = createButton(title: "Cover Vertical", action: #selector(showCoverVertical))
    let button2 = createButton(title: "Flip Horizontal", action: #selector(showFlipHorizontal))
    let button3 = createButton(title: "Cross Dissolve", action: #selector(showCrossDissolve))
    let button4 = createButton(title: "Partial Curl", action: #selector(showPartialCurl))
    
    // Add buttons to view and layout them
    view.addSubview(button1)
    view.addSubview(button2)
    view.addSubview(button3)
    view.addSubview(button4)
    
    let margin: CGFloat = 20.0
    let spacing: CGFloat = 10.0
    let buttonWidth = (view.frame.width - margin * 2 - spacing * 3) / 4
    let buttonHeight: CGFloat = 50.0
    
    button1.frame = CGRect(x: margin, y: view.frame.height - buttonHeight - margin - 100, width: buttonWidth, height: buttonHeight)
    button2.frame = CGRect(x: button1.frame.maxX + spacing, y: button1.frame.origin.y, width: buttonWidth, height: buttonHeight)
    button3.frame = CGRect(x: button2.frame.maxX + spacing, y: button1.frame.origin.y, width: buttonWidth, height: buttonHeight)
    button4.frame = CGRect(x: button3.frame.maxX + spacing, y: button1.frame.origin.y, width: buttonWidth, height: buttonHeight)
  }
  
  func createButton(title: String, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }
  
  @objc func showCoverVertical() {
    let viewController = TransparentViewController()
    viewController.modalPresentationStyle = .overCurrentContext
    viewController.modalTransitionStyle = .coverVertical
    present(viewController, animated: true, completion: nil)
  }
  
  @objc func showFlipHorizontal() {
    let viewController = TransparentViewController()
    viewController.modalPresentationStyle = .overCurrentContext
    viewController.modalTransitionStyle = .flipHorizontal
    present(viewController, animated: true, completion: nil)
  }
  
  @objc func showCrossDissolve() {
    let viewController = TransparentViewController()
    viewController.modalPresentationStyle = .overCurrentContext
    viewController.modalTransitionStyle = .crossDissolve
    present(viewController, animated: true, completion: nil)
  }
  
  @objc func showPartialCurl() {
    let viewController = TransparentViewController()
    viewController.modalPresentationStyle = .overCurrentContext
    viewController.modalTransitionStyle = .partialCurl
    present(viewController, animated: true, completion: nil)
  }
}

class TransparentViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the background color to transparent
    view.backgroundColor = .black.withAlphaComponent(0.5)
    
    // Add a button to the center of the view
    let button = UIButton(type: .system)
    button.setTitle("Dismiss", for: .normal)
    button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    view.addSubview(button)
    
    // Layout the button in the center of the view
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  @objc func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}
