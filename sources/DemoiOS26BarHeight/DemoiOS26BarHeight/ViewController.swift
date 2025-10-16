import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // print navigation bar height
    let height = navigationController?.navigationBar.frame.height
    print(height ?? "null")  // 54.0 for iOS 26.0
  }

}
