//
//  SomeView.swift
//  TestAutoLayoutWithAnimation
//
//  Created by Brook_Mobius on 2023/1/30.
//

import UIKit

class SomeView: UIView {

  var button: UIView!
  
  var usesFrameLayout = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if usesFrameLayout {
      applyFrameLayout()
    }
    
    print(subviews[0].frame)
  }
  
  func setupUI() {
    button = UIView()
    button.backgroundColor = .yellow
    addSubview(button)
    
    if !usesFrameLayout {
      applyAutoLayout()
    }
  }
  
  func applyFrameLayout() {
    button.frame = CGRect(x: 10, y: 10, width: bounds.width - 10 * 2, height: bounds.height - 10 * 2)
  }
  
  func applyAutoLayout() {
    button.translatesAutoresizingMaskIntoConstraints = false
    
    let trailing = {
      let ret = button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
      ret.priority = .defaultHigh
      return ret
    }()
    
    let bottom = {
      let ret = button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
      ret.priority = .defaultHigh
      return ret
    }()
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      trailing,
      bottom,
    ])
  }
  
  static var viewHeght: CGFloat = 200
}
