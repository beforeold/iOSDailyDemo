//
//  SomeView.swift
//  TestAutoLayoutWithAnimation
//
//  Created by Brook_Mobius on 2023/1/30.
//

import UIKit

class SomeView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    print(subviews[0].frame)
  }
  
  func setupUI() {
    let button = UIButton(type: .custom)
    button.setTitle("Click", for: .normal)
    addSubview(button)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .yellow
    
    clipsToBounds = true
    
//    button.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      {
        let ret = button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ret.priority = .defaultHigh
        return ret
      }(),
      button.heightAnchor.constraint(equalToConstant: 80),
    ])
  }
  
  static var viewHeght: CGFloat = 100
}
