import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = .init(systemItem: .search)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // printSubview(self.navigationController?.navigationBar ?? UIView())

    var targetView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
    // targetView = targetView?.superview?.superview?.superview
    targetView?.backgroundColor = .blue
    print("igemView frame", targetView?.frame ?? .zero)

    printSubview(targetView ?? UIView())
  }

  private func printSubview(_ view: UIView) {
    print(type(of: view), view.bounds.size, view.layer.cornerRadius)

    view.subviews.forEach { view in
      printSubview(view)
    }
  }

}

#Preview {
  UINavigationController(
    rootViewController: ViewController()
  )
}
