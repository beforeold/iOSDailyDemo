import UIKit
import ObjectiveC.runtime

extension UITabBarController {
  // Call once at launch to hide tab bars for every UITabBarController lifecycle.
  static func installTabBarHooks() {
    _ = swizzleViewDidLoad
    _ = swizzleSelectedIndex
    _ = swizzleSelectedViewController
    UIViewController.installTabBarHooks2()
    UITabBar.installTabBarViewHooks()
  }

  private static let swizzleViewDidLoad: Void = {
    let cls = UITabBarController.self

    guard let original = class_getInstanceMethod(cls, #selector(UIViewController.viewDidLoad)),
          let swizzled = class_getInstanceMethod(cls, #selector(UITabBarController.hook_viewDidLoad)) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  private static let swizzleSelectedIndex: Void = {
    let cls = UITabBarController.self

    guard let original = class_getInstanceMethod(cls, NSSelectorFromString("setSelectedIndex:")),
          let swizzled = class_getInstanceMethod(cls, #selector(UITabBarController.hook_setSelectedIndex(_:))) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  private static let swizzleSelectedViewController: Void = {
    let cls = UITabBarController.self

    guard let original = class_getInstanceMethod(cls, NSSelectorFromString("setSelectedViewController:")),
          let swizzled = class_getInstanceMethod(cls, #selector(UITabBarController.hook_setSelectedViewController(_:))) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  @objc private func hook_viewDidLoad() {
    self.hook_viewDidLoad()
    print("[TabBarHook] hiding tabBar for", self)
    tabBar.isHidden = true
  }

  @objc private func hook_setSelectedIndex(_ index: Int) {
    self.hook_setSelectedIndex(index)
    print("[TabBarHook] selectedIndex ->", index, "on", type(of: self))
    tabBar.isHidden = true
  }

  @objc private func hook_setSelectedViewController(_ viewController: UIViewController?) {
    self.hook_setSelectedViewController(viewController)
    if let vc = viewController {
      print("[TabBarHook] selectedViewController ->", type(of: vc), "on", type(of: self))
    } else {
      print("[TabBarHook] selectedViewController -> nil on", type(of: self))
    }
    tabBar.isHidden = true
  }
}

extension UITabBar {
  fileprivate static func installTabBarViewHooks() {
    _ = swizzleTabBarLayoutSubviews
  }

  private static let swizzleTabBarLayoutSubviews: Void = {
    let cls = UITabBar.self

    guard let original = class_getInstanceMethod(cls, #selector(UITabBar.layoutSubviews)),
          let swizzled = class_getInstanceMethod(cls, #selector(UITabBar.tabBar_hook_layoutSubviews)) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  @objc private func tabBar_hook_layoutSubviews() {
    self.tabBar_hook_layoutSubviews()
    print("[TabBarHook] layoutSubviews hiding UITabBar", type(of: self))
    isHidden = true
  }
}

extension UIViewController {
  fileprivate static func installTabBarHooks2() {
    _ = swizzleTabBarAddChild
    _ = swizzleTabBarViewDidAppear
    _ = swizzleTabBarViewDidLayoutSubviews
  }

  private static let swizzleTabBarAddChild: Void = {
    let cls = UIViewController.self

    guard let original = class_getInstanceMethod(cls, #selector(UIViewController.addChild(_:))),
          let swizzled = class_getInstanceMethod(cls, #selector(UIViewController.tabBar_hook_addChild(_:))) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  private static let swizzleTabBarViewDidAppear: Void = {
    let cls = UIViewController.self

    guard let original = class_getInstanceMethod(cls, #selector(UIViewController.viewDidAppear(_:))),
          let swizzled = class_getInstanceMethod(cls, #selector(UIViewController.tabBar_hook_viewDidAppear(_:))) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  private static let swizzleTabBarViewDidLayoutSubviews: Void = {
    let cls = UIViewController.self

    guard let original = class_getInstanceMethod(cls, #selector(UIViewController.viewDidLayoutSubviews)),
          let swizzled = class_getInstanceMethod(cls, #selector(UIViewController.tabBar_hook_viewDidLayoutSubviews)) else {
      return
    }

    method_exchangeImplementations(original, swizzled)
  }()

  @objc private func tabBar_hook_addChild(_ child: UIViewController) {
    self.tabBar_hook_addChild(child)

    print("[TabBarHook] addChild caller:", type(of: self), "child:", type(of: child))

    guard let tabBarController = child as? UITabBarController else { return }

    print("[TabBarHook] addChild, hiding tabBar for", type(of: tabBarController))
    tabBarController.tabBar.isHidden = true
  }

  @objc private func tabBar_hook_viewDidAppear(_ animated: Bool) {
    self.tabBar_hook_viewDidAppear(animated)
    hideTabBarsInHierarchy(startingAt: self)
    hideTabBarsInViewTree(view)
  }

  @objc private func tabBar_hook_viewDidLayoutSubviews() {
    self.tabBar_hook_viewDidLayoutSubviews()
    hideTabBarsInHierarchy(startingAt: self)
    hideTabBarsInViewTree(view)
  }

  private func hideTabBarsInHierarchy(startingAt root: UIViewController) {
    var stack: [UIViewController] = [root]

    while let current = stack.popLast() {
      if let tabBarController = current as? UITabBarController {
        print("[TabBarHook] traverse hiding tabBar for", type(of: tabBarController))
        tabBarController.tabBar.isHidden = true
      }

      stack.append(contentsOf: current.children)
    }
  }

  private func hideTabBarsInViewTree(_ root: UIView?) {
    guard let root = root else { return }

    if let tabBar = root as? UITabBar {
      print("[TabBarHook] view tree hiding UITabBar for", type(of: tabBar))
      tabBar.isHidden = true
    }

    for subview in root.subviews {
      hideTabBarsInViewTree(subview)
    }
  }
}
