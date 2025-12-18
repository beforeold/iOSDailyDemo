import UIKit

class ViewController: UIViewController {

  private let tabBarCoverHeight: CGFloat = 88
  private let horizontalPadding: CGFloat = 16
  private var tabBarCover: UIView?

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
    let height: CGFloat = 500
    let safeBottom = view.safeAreaInsets.bottom
    let y = max(0, view.bounds.height - safeBottom - height)
    let x = horizontalPadding
    let width = view.bounds.width - horizontalPadding * 2

    docVC.view.frame = CGRect(
      x: x,
      y: y,
      width: width,
      height: height
    )

    updateTabBarCover(for: docVC.view.frame)
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

  private func updateTabBarCover(for docFrame: CGRect) {
    let coverFrame = CGRect(
      x: docFrame.minX,
      y: docFrame.maxY - tabBarCoverHeight,
      width: docFrame.width,
      height: tabBarCoverHeight
    )

    let coverView: UIView
    if let existing = tabBarCover {
      coverView = existing
    } else {
      let newCover = UIView()
      newCover.backgroundColor = .lightGray
      newCover.isUserInteractionEnabled = false
      tabBarCover = newCover
      coverView = newCover
      view.addSubview(coverView)
    }

    coverView.frame = coverFrame
    view.bringSubviewToFront(coverView)
  }
}
