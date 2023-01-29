//
//  CustomPresentAnimationController.swift
//  CustomTransitions
//
//  Created by Brook_Mobius on 2023/1/29.
//  Copyright © 2023 Appcoda. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject {
  
}

extension CustomPresentAnimationController: UIViewControllerAnimatedTransitioning {
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
    
    let bounds = UIScreen.main.bounds
    toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, -bounds.size.height)
    containerView.addSubview(toViewController.view)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      fromViewController.view.alpha = 0.5
      toViewController.view.frame = finalFrameForVC
    } completion: { _ in
      transitionContext.completeTransition(true)
      fromViewController.view.alpha = 1.0
    }
  }
}
