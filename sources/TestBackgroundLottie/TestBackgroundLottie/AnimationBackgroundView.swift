import Foundation
import Lottie
import UIKit

class AnimationBackgroundView: UIView {
  private var lottieView: LottieAnimationView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  private func setup() {
    let animation = LottieAnimation.named("app_bg")
    let lottieView = LottieAnimationView(animation: animation)
    lottieView.loopMode = .loop
    lottieView.contentMode = .scaleAspectFill
    lottieView.play()
    lottieView.frame = bounds
    lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(lottieView)

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
    blurView.frame = lottieView.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    lottieView.addSubview(blurView)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

  }
}

@available(iOS 17.0, *)
#Preview {
  AnimationBackgroundView(frame: UIScreen.main.bounds)
}
