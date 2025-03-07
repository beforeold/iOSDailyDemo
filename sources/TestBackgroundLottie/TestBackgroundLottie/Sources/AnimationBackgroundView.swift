import Foundation
import Lottie
import UIKit

class AnimationBackgroundView: UIView {
  private var lottieView: UIView!

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
    lottieView.contentMode = .scaleToFill
    lottieView.play()
    print("logHierarchyKeypaths")
    let paths = lottieView.allHierarchyKeypaths()
    print(paths)

//    let rotationProvider = FloatValueProvider(.pi / -2)
//    // Specify the keypath for the rotation property
//    let rotationKeypath = AnimationKeypath(keypath: "LayerName.Transform.Rotation")
//    // Assign the value provider to the animation view
//    lottieView.setValueProvider(rotationProvider, keypath: rotationKeypath)

    lottieView.frame = self.bounds
    lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

//    let lottieView = UIView()
//    lottieView.backgroundColor = .blue

    self.lottieView = lottieView
    addSubview(lottieView)

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
    blurView.frame = lottieView.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    self.addSubview(blurView)

    let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
    self.addGestureRecognizer(tap)
  }

  @objc func onTap() {
    self.updateTransform()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    //    DispatchQueue.main.async { [weak self] in
    //      guard let self else { return }
//    updateTransform()
    //    }
  }

  func updateTransform() {
    uiviewTransform()
  }

  func lottieTransform() {
    print(self.bounds, "vs.", self.frame)
    return

    // Specify the keypath for the rotation property
    let rotationKeypath = AnimationKeypath(keypath: "LayerName.Transform.Rotation")

    if bounds.size.width > bounds.size.height {
      let rotationProvider = FloatValueProvider(0)
      // Assign the value provider to the animation view
      (self.lottieView as? LottieAnimationView)?.setValueProvider(rotationProvider, keypath: rotationKeypath)
    } else {
      let rotationProvider = FloatValueProvider(.pi / -2)
      (self.lottieView as? LottieAnimationView)?.setValueProvider(rotationProvider, keypath: rotationKeypath)
    }
  }

  func uiviewTransform() {
    print("bounds", self.bounds)

    if bounds.size.width > bounds.size.height {
      // landscape
      lottieView.transform = .identity
      lottieView.frame = self.bounds
      print("landscape")
    } else {
      // portrait
      print("portrait")
      // rotate the frame, then transform
      let origin = (bounds.size.height - bounds.size.width) / 2
      let frame = CGRect(x: -origin, y: origin, width: bounds.size.height, height: bounds.size.width)
      lottieView.frame = frame
      print("lottie frame", frame)
      lottieView.transform = .identity.rotated(by: .pi / -2)
    }
  }
}

class TestView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    let rect = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
    rect.backgroundColor = .blue
    self.addSubview(rect)
    rect.transform = .init(rotationAngle: .pi / 4)
  }



//  override func layoutSubviews() {
//    super.layoutSubviews()
//
//    self.subviews[0].transform = subviews[0].transform.rotated(by: .pi / 4)
//  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

@available(iOS 17.0, *)
#Preview {
  AnimationBackgroundView()
}

@available(iOS 17.0, *)
#Preview {
  TestView()
}

class TransformAnimationViewController: UIViewController {

  let squareView = UIView()
  var rotationAngle: CGFloat = 0  // 记录当前旋转角度

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    // 创建一个方块
    squareView.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
    squareView.backgroundColor = .blue
    view.addSubview(squareView)

    // 创建一个按钮，点击后执行旋转动画
    let rotateButton = UIButton(type: .system)
    rotateButton.frame = CGRect(x: 100, y: 400, width: 150, height: 50)
    rotateButton.setTitle("Rotate", for: .normal)
    rotateButton.addTarget(self, action: #selector(rotateSquare), for: .touchUpInside)
    view.addSubview(rotateButton)
  }

  @objc func rotateSquare() {
    rotationAngle += .pi / 4  // 每次旋转 45 度

    UIView.animate(
      withDuration: 0.5, delay: 0, options: .curveEaseInOut,
      animations: {
        self.squareView.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
      }, completion: nil)
  }
}

@available(iOS 17.0, *)
#Preview {
  TransformAnimationViewController()
}

import UIKit

class TransformAnimationDemoViewController: UIViewController {

    let animatedView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置视图背景颜色
        view.backgroundColor = .white

        // 创建并设置 animatedView
        animatedView.backgroundColor = .blue
        animatedView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(animatedView)

        // 添加按钮以触发动画
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Animation", for: .normal)
        startButton.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        view.addSubview(startButton)
    }

    @objc func startAnimation() {
        // 1. 缩放动画
        let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        // 2. 旋转动画
        let rotateTransform = CGAffineTransform(rotationAngle: .pi / 2) // 旋转 90 度

        // 3. 平移动画
        let translateTransform = CGAffineTransform(translationX: 50, y: 50)

        // 组合变换
        let combinedTransform = scaleTransform
        .concatenating(rotateTransform)
        .concatenating(translateTransform)

        // 使用 UIView.animate 实现动画
        UIView.animate(withDuration: 2.0, animations: {
            self.animatedView.transform = combinedTransform
        }) { (finished) in
            // 动画完成后恢复原始状态
            UIView.animate(withDuration: 2.0) {
                self.animatedView.transform = .identity // 恢复到初始状态
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
  TransformAnimationDemoViewController()
}
