import UIKit
internal import UniformTypeIdentifiers

class ViewController: UIViewController {

  private let horizontalPadding: CGFloat = 0

  private let docVC: UIDocumentBrowserViewController = {
    let controller = UIDocumentBrowserViewController(
      forOpening: [.mpeg4Movie],
    )
    return controller
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .blue

    view.addSubview(docVC.view)
    addChild(docVC)
    docVC.didMove(toParent: self)
    docVC.delegate = self

    docVC.loadViewIfNeeded()
    hideTabBarIfNeeded(startingAt: docVC)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    layoutDocumentBrowser()
  }

  private func layoutDocumentBrowser() {
    let visibleHeight: CGFloat = 500
    let hideOffset: CGFloat = 120  // push the bottom (tab bar) beyond the screen
    let safeBottom = view.safeAreaInsets.bottom
    let y = max(0, view.bounds.height - safeBottom - visibleHeight)
    let x = horizontalPadding
    let width = view.bounds.width - horizontalPadding * 2

    docVC.allowsDocumentCreation = false
    docVC.allowsPickingMultipleItems = true
    docVC.view.frame = CGRect(
      x: x,
      y: y,
      width: width,
      height: visibleHeight + hideOffset
    )
    docVC.view.layer.cornerRadius = 16
    docVC.view.clipsToBounds = true
  }

  private func hideTabBarIfNeeded(startingAt root: UIViewController) {
    var stack: [UIViewController] = [root]

    while let current = stack.popLast() {
      if let tabBarController = current as? UITabBarController {
        tabBarController.tabBar.isHidden = true
        // Keep walking children in case there are nested tab bars.
        print("finded", tabBarController)
      }

      stack.append(contentsOf: current.children)
    }
  }
}

extension ViewController: UIDocumentBrowserViewControllerDelegate {
  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didRequestDocumentCreationWithHandler importHandler:
      @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void
  ) {
    importHandler(nil, .none)
  }
}
