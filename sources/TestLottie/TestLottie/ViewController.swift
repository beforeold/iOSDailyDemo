//
//  ViewController.swift
//  TestLottie
//
//  Created by Brook_Mobius on 7/20/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    
  }


}

import SwiftUI

struct Lottie_Prviews: PreviewProvider {
  static func buildLottieView(name: String) -> UIView {
    let view = LottieAnimationView()
    view.animation = .named(name)
    view.loopMode = .loop
    view.play()
    
    view.backgroundColor = .lightGray
    
    return view
  }
  
  static var previews: some View {
    buildLottieView(name: "progress2.json")
      .previewed()
      .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  }
}
