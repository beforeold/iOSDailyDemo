import UIKit

class ViewController: UIViewController {

  private let horizontalPadding: CGFloat = 16

  private let docVC: UIDocumentBrowserViewController = {
    let controller = UIDocumentBrowserViewController(
      forOpeningFilesWithContentTypes: ["mp3"]
    )
    return controller
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .blue

    view.addSubview(docVC.view)
    addChild(docVC)
    docVC.didMove(toParent: self)

    docVC.loadViewIfNeeded()
    hideTabBarIfNeeded(startingAt: docVC)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    layoutDocumentBrowser()
  }

  private func layoutDocumentBrowser() {
    let visibleHeight: CGFloat = 500
    let hideOffset: CGFloat = 120 // push the bottom (tab bar) beyond the screen
    let safeBottom = view.safeAreaInsets.bottom
    let y = max(0, view.bounds.height - safeBottom - visibleHeight)
    let x = horizontalPadding
    let width = view.bounds.width - horizontalPadding * 2

    docVC.view.frame = CGRect(
      x: x,
      y: y,
      width: width,
      height: visibleHeight + hideOffset
    )
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
