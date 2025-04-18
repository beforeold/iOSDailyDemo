//
//  ViewController.swift
//  TestCollectionViewReload
//
//  Created by Brook_Mobius on 4/18/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  private var collectionView: UICollectionView!
  private var data = (0..<20).map { "Item \($0)" }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Collection View"

    setupCollectionView()
    setupNavigationItem()
  }

  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    view.addSubview(collectionView)
  }

  private func setupNavigationItem() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Refresh", style: .plain, target: self, action: #selector(refreshItems))
  }

  @objc private func refreshItems() {
    let indexPathsToReload = [IndexPath(item: 400, section: 0)]
//    for indexPath in indexPathsToReload {
//      data[indexPath.item] = "Updated \(indexPath.item)"
//    }
    collectionView.reloadItems(at: indexPathsToReload)
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    cell.backgroundColor = .lightGray

    for subview in cell.contentView.subviews {
      subview.removeFromSuperview()
    }

    let label = UILabel(frame: cell.contentView.bounds)
    label.textAlignment = .center
    label.text = data[indexPath.item]
    cell.contentView.addSubview(label)

    return cell
  }
}
