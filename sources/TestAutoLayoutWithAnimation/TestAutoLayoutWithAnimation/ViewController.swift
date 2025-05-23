//
//  ViewController.swift
//  TestAutoLayoutWithAnimation
//
//  Created by Brook_Mobius on 2023/1/30.
//

import UIKit

class ViewController: UIViewController {

  let grayView = SomeView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    grayView.frame = CGRectMake(100, 100, SomeView.viewHeght, SomeView.viewHeght)
    grayView.backgroundColor = .lightGray
    view.addSubview(grayView)
  }

  var count = 0
  
  // 测试在 some view 调用动画函数时， some view 的子视图的目标 frame.size 为 0
  // 而导致动画执行一开始子视图就消失不见
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if count % 2 == 0 {
      UIView.animate(withDuration: 2) {
        // self.toCenterAnimation()
        // self.toOriginAnimation()
        self.toOriginAnimationZeroSize()
      }
    } else {
      self.grayView.frame = CGRectMake(100, 100, SomeView.viewHeght, SomeView.viewHeght)
    }
    
    self.count += 1
  }
  
  /*
   得到一个线索，尝试了一下可以解决问题（虽然还不理解），解法就是在动画 block 中使用

   self.view.layoutIfNeeded()

   （不是 grayView 调用）

   参考：
   Frames changing suddenly instead of animating [iOS]
   https://stackoverflow.com/a/48668784/7333880
   */
  
  func toCenterAnimation() {
    let center = self.grayView.center
    self.grayView.frame.size = CGSize(width: 100, height: 100)
    self.grayView.center = center
    
    self.view.layoutIfNeeded()
  }
  
  func toOriginAnimation() {
    self.grayView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    
    self.view.layoutIfNeeded()
  }
  
  func toOriginAnimationZeroSize() {
    self.grayView.frame = CGRect(x: 100, y: 100, width: 0, height: 0)
    
    self.view.layoutIfNeeded()
  }
}

