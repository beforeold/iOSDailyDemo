import UIKit

// 
class ViewController: UIViewController {

  private let items = Array(0..<20)
  private var currentIndex = 0

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: ViewController.makeLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isPagingEnabled = true
    collectionView.register(IndexCell.self, forCellWithReuseIdentifier: IndexCell.reuseIdentifier)
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    collectionView.contentInsetAdjustmentBehavior = .never
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  // Keep track of the page we're on so rotation can snap back to the same item.
  private func pageIndex() -> Int {
    guard collectionView.bounds.height > 0 else { return currentIndex }
    let rawIndex = Int(round(collectionView.contentOffset.y / collectionView.bounds.height))
    return max(0, min(items.count - 1, rawIndex))
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    let targetIndex = pageIndex()
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { _ in
      //self.collectionView.collectionViewLayout.invalidateLayout()
      let indexPath = IndexPath(item: targetIndex, section: 0)
      self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }, completion: { _ in
      let indexPath = IndexPath(item: targetIndex, section: 0)
      // self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
      // self.currentIndex = targetIndex
      print("Transition finished at index: \(targetIndex)")
    })
  }

  private static func makeLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      return section
    }
  }

}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexCell.reuseIdentifier,
                                                        for: indexPath) as? IndexCell else {
      return UICollectionViewCell()
    }
    cell.configure(with: indexPath.item)
    return cell
  }
}

extension ViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    currentIndex = pageIndex()
    print("Current index after decelerating: \(currentIndex)")
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard !decelerate else { return }
    currentIndex = pageIndex()
    print("Current index after dragging: \(currentIndex)")
  }
}

final class IndexCell: UICollectionViewCell {
  static let reuseIdentifier = "IndexCell"

  private let indexLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.textColor = .label
    return label
  }()

  override init(frame: CGRect) {
    print("init cell")

    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    contentView.addSubview(indexLabel)
    NSLayoutConstraint.activate([
      indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      indexLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      indexLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      indexLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with index: Int) {
    print("Configuring cell with index: \(index)")

    indexLabel.text = "Item \(index)"
  }
}
