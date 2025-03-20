import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let viewControllerToPresent = MyViewController()
    viewControllerToPresent.preferredContentSize = UIScreen.main.bounds.size
    if let sheet = viewControllerToPresent.sheetPresentationController {
      sheet.prefersGrabberVisible = true
      sheet.detents = [.custom(resolver: { context in
        context.maximumDetentValue * 0.999
      })]
//      sheet.largestUndimmedDetentIdentifier = .large
      sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//      sheet.prefersEdgeAttachedInCompactHeight = true
//      sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
    }

    present(viewControllerToPresent, animated: true, completion: nil)

  }

}

class MyViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .blue
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    print(self.presentingViewController!.view.subviews)
  }
}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
