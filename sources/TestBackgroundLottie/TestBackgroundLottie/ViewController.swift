import Lottie
import SnapKit
import SwiftUI
import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let animation = LottieAnimation.named("app_bg")
    let lottieView = LottieAnimationView(animation: animation)
    lottieView.loopMode = .loop
    lottieView.play()

    view.addSubview(lottieView)
    lottieView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    lottieView.contentMode = .scaleAspectFill

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
    lottieView.addSubview(blurView)
    blurView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    let white = UIView(frame: .init(x: 100, y: 200, width: 200, height: 200))
    white.layer.cornerRadius = 24
    white.backgroundColor = .systemBackground
    view.addSubview(white)
  }

}

#Preview {
  ViewController()
}
