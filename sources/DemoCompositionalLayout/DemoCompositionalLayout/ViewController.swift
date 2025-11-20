import UIKit

class ViewController: UIViewController {

  private let items = Array(0..<20)

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: ViewController.makeLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    collectionView.dataSource = self
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
    indexLabel.text = "Item \(index)"
  }
}
