import SwiftUI
import UIKit

class ViewController: ViewControllerDemo {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

}

class ViewControllerDemo: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  var collectionView: UICollectionView!
  let headerViewHeight: CGFloat = 100

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    // Layout
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 100, height: 100)

    // CollectionView
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self

    // Adjust content inset to make space for the header
    collectionView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
    view.addSubview(collectionView)

    // Add header view directly
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight))
    headerView.backgroundColor = .systemOrange

    let label = UILabel(frame: headerView.bounds)
    label.text = "CollectionView Header"
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textAlignment = .center
    headerView.addSubview(label)

    collectionView.addSubview(headerView)
  }

  // MARK: - DataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 30
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    cell.backgroundColor = .systemBlue
    return cell
  }

  // Register cells
  override func loadView() {
    super.loadView()
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
  }
}

#Preview {
  ViewController()
}
