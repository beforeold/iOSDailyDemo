//
//  ViewController.swift
//  TestUIViewLifecycle
//
//  Created by Brook_Mobius on 8/3/23.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Home"
    
    let myView = MyView(frame: .init(x: 100, y: 100, width: 100, height: 100))
    myView.backgroundColor = .red
    self.view.addSubview(myView)
    
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = Double.pi * 2.0
    rotationAnimation.duration = 1
    rotationAnimation.repeatCount = 999999
     rotationAnimation.delegate = self
    myView.layer.add(rotationAnimation, forKey: "key")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let next = NextViewController()
    
    navigationController?.pushViewController(next, animated: true)
  }
  
  func animationDidStart(_ anim: CAAnimation) {
    print(#function)
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    print(#function)
  }
}


class MyLayer: CALayer {
  override func removeAllAnimations() {
    super.removeAllAnimations()
  }
  
  override func removeAnimation(forKey key: String) {
    super.removeAnimation(forKey: key)
  }
}

class MyView: UIView {
  override class var layerClass: AnyClass {
    return MyLayer.self
  }
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    print(#function, newWindow?.description ?? "null")
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    print(#function, newSuperview?.description ?? "null")
  }
}
