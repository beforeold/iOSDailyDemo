import UIKit
import SwiftUI


func foo() {
  var view = makeView()
  // var view: some View = makeView()

  view = makeView()

  print(view)
}

func makeView() -> some View {
  Text("Hello")
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

}
