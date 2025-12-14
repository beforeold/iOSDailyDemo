import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()


    let docVC = UIDocumentBrowserViewController(
      forOpeningFilesWithContentTypes: ["mp3"]
    )

    docVC.view.frame = CGRect(x: 0, y: 220, width: 300, height: 300)
    view.addSubview(docVC.view)
    addChild(docVC)

    view.backgroundColor = .blue
  }

}
