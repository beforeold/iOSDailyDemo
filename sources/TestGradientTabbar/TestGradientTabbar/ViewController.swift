import SwiftUI
import UIKit

/// randome from 0 - 1
private func randomColor() -> Color {
  // Color(uiColor: UIColor(red: Double(index) / 100 , green: Double(index) / 100 , blue: Double(index) / 100 , alpha: 1))
  Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
}

struct ListView: View {
  var body: some View {
    List(0..<100) { index in
      Text("row: \(index)")
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
          randomColor()
        )
    }
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let listView = ListView()
    let controller = UIHostingController(rootView: listView)
    addChild(controller)
    view.addSubview(controller.view)
    controller.view.backgroundColor = .clear
    controller.view.frame = view.bounds
    controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
}


import UIKit

//class CustomTabBar: UITabBar {
//
//  private let blurEffectView: UIVisualEffectView = {
//    let blurEffect = UIBlurEffect(style: .light)
//    let blurEffectView = UIVisualEffectView(effect: blurEffect)
//    blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//    return blurEffectView
//  }()
//
//  private let gradientLayer: CAGradientLayer = {
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor]
//    return gradientLayer
//  }()
//
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    setupBlurEffect()
//  }
//
//  required init?(coder: NSCoder) {
//    super.init(coder: coder)
//    setupBlurEffect()
//  }
//
//  private func setupBlurEffect() {
//    addSubview(blurEffectView)
//    sendSubviewToBack(blurEffectView)
//
//    // 约束使模糊视图高出 tabBar 的高度 16 点
//    NSLayoutConstraint.activate([
//      blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
//      blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
//      blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
//      blurEffectView.topAnchor.constraint(equalTo: topAnchor, constant: -100)
//    ])
//
//    // 添加渐变层
//    blurEffectView.contentView.layer.addSublayer(gradientLayer)
//  }
//
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    gradientLayer.frame = blurEffectView.bounds
//  }
//}

import UIKit

import UIKit

class CustomTabBar: UITabBar {
  private var controller: UIViewController!
  private var blurEffectView: UIView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupBlurEffect()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupBlurEffect()
  }

  private func setupBlurEffect() {
    let view = TransparentBlurView(removeAllFilters: true)
      .blur(radius: 16, opaque: false)
      .padding([.horizontal, .bottom], -16)

    controller = UIHostingController(rootView: view)
    controller.view.backgroundColor = .clear
    blurEffectView = controller.view
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(blurEffectView)
    sendSubviewToBack(blurEffectView)

    // 约束使模糊视图高出 tabBar 的高度 16 点
    NSLayoutConstraint.activate([
      blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
      blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
      blurEffectView.topAnchor.constraint(equalTo: topAnchor, constant: -16)
    ])
  }
}

class CustomTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

        setupCustomTabBar()
  }

  private func setupCustomTabBar() {
    let customTabBar = CustomTabBar()
    setValue(customTabBar, forKey: "tabBar")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    print(self.tabBar.subviews)
  }
}
