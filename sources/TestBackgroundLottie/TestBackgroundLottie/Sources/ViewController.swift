import Lottie
import SnapKit
import SwiftUI
import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    print(#function)

    //    let testView = TestView(frame: CGRect(x: 100, y: 200, width: 300, height: 300))
    //    testView.backgroundColor = .gray
    //    view.addSubview(testView)

    //      testLottie()

    testBackground()
  }

  private func testBackground() {
    let background = AnimationBackgroundView(frame: UIScreen.main.bounds)
    background.backgroundColor = .gray
    background.frame = view.bounds
    background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(background)
    background.uiviewTransform()

    //    background.snp.makeConstraints { make in
    //      make.edges.equalTo(0)
    //    }
    //    background.transform = .identity.rotated(by: .pi / 4)

    //    let bounds = view.bounds
    //    let origin = (bounds.size.height - bounds.size.width) * 0.5
    //    let frame = CGRect(x: -origin, y: origin, width: bounds.size.height, height: bounds.size.width)
    //    background.subviews[0].frame = frame
    //    print("lottie frame", frame)
    //    background.subviews[0].transform = .identity.rotated(by: .pi / 2)

//    background.updateTransform()
  }

  private func testLottie() {
    let animation = LottieAnimation.named("app_bg")
    let lottieView = LottieAnimationView(animation: animation)
    lottieView.loopMode = .loop
    lottieView.contentMode = .scaleToFill
    lottieView.play()

    view.addSubview(lottieView)

    let x = (UIScreen.main.bounds.height - UIScreen.main.bounds.width) * 0.5
    lottieView.frame = CGRect(
      x: -x,
      y: x,
      width: UIScreen.main.bounds.height,
      height: UIScreen.main.bounds.width
    )
    print("lottie frame", lottieView.frame)
    lottieView.transform = .identity.rotated(by: .pi * 0.5)

    //    let style: UIBlurEffect.Style? = .init(rawValue: 100)
    //    print(style ?? "null style")
    //
    //    let blurView = UIVisualEffectView(
    //      effect: UIBlurEffect(
    //        style: .systemThickMaterial
    //      )
    //    )
    //    lottieView.addSubview(blurView)
    //    blurView.snp.makeConstraints { make in
    //      make.edges.equalToSuperview()
    //    }
    //
    //    let white = UIView(frame: .init(x: 100, y: 200, width: 200, height: 200))
    //    white.layer.cornerRadius = 24
    //    white.backgroundColor = .systemBackground
    //    view.addSubview(white)
  }

}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
