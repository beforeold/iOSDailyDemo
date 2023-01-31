//
//  CustomDismissAnimationController.swift
//  CustomTransitions
//
//  Created by Brook_Mobius on 2023/1/30.
//  Copyright © 2023 Appcoda. All rights reserved.
//

import UIKit

class CustomDismissAnimationController: NSObject {

}

extension CustomDismissAnimationController: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 2
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from),
          let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
    
    toViewController.view.frame = finalFrameForVC
    toViewController.view.alpha = 0.5
    
        let containerView = transitionContext.containerView
//        containerView.addSubview(toViewController.view)
//        containerView.sendSubviewToBack(toViewController.view)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      let finalFrameForFromVC = CGRectInset(
        fromViewController.view.frame,
        fromViewController.view.frame.width * 0.5,
        fromViewController.view.frame.height * 0.5
      )
      fromViewController.view.frame = finalFrameForFromVC
      
      containerView.layoutIfNeeded()
      print(containerView)
      toViewController.view.alpha = 1.0
      
    } completion: { _ in
      print(fromViewController)
      transitionContext.completeTransition(true)
    }
  }
}
