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
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from),
          let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
    let containerView = transitionContext.containerView
    
    toViewController.view.frame = finalFrameForVC
    toViewController.view.alpha = 0.5
//    containerView.addSubview(toViewController.view)
//    containerView.sendSubviewToBack(toViewController.view)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      fromViewController.view.frame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.width * 0.5, fromViewController.view.frame.height * 0.5)
      toViewController.view.alpha = 1.0
    } completion: { _ in
      transitionContext.completeTransition(true)
    }
  }
}
