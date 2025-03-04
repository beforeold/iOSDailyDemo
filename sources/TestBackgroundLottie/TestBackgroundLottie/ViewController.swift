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
    lottieView.contentMode = .scaleAspectFill
    lottieView.play()

    view.addSubview(lottieView)

    let x = (UIScreen.main.bounds.height - UIScreen.main.bounds.width) * 0.5
    lottieView.frame = CGRect(
      x: -x,
      y: x,
      width: UIScreen.main.bounds.height,
      height: UIScreen.main.bounds.width
    )
    lottieView.transform = .identity.rotated(by: .pi * 0.5)

    let style: UIBlurEffect.Style? = .init(rawValue: 100)
    print(style ?? "null style")

    let blurView = UIVisualEffectView(
      effect: UIBlurEffect(
        style: .systemThickMaterial
      )
    )
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
