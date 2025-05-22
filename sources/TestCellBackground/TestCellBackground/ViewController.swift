import SwiftUI
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

    let tableView = UITableView(
      frame: UIScreen.main.bounds,
      style: .insetGrouped
    )

    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self


    tableView.register(Cell.self, forCellReuseIdentifier: "cell")
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    cell.textLabel?.text = "\(indexPath.row)"

    return cell
  }

}

class Cell: UITableViewCell {

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    print(#function, highlighted)
    if highlighted {
      print(self.backgroundColor ?? "Null", self.contentView.backgroundColor ?? "null")
      print(self.subviews.first?.subviews ?? "null")

      let back = self.subviews.first?.subviews.first
      let color = back?.backgroundColor as! UIColor

      var red: CGFloat = 0.0
      var green: CGFloat = 0.0
      var blue: CGFloat = 0.0
      var alpha: CGFloat = 0.0
      _ = UIColor.tertiarySystemGroupedBackground.getRed(
        &red,
        green: &green,
        blue: &blue,
        alpha: &alpha
      )
      print(red, green, blue, alpha)
    }

  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    print(#function, selected)
  }
}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
