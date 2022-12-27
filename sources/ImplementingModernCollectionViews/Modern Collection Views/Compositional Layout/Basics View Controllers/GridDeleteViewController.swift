//
//  GridDeleteViewController.swift
//  Modern Collection Views
//
//  Created by Brook_Mobius on 2022/12/26.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class GridDeleteViewController: UIViewController {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grid"
        configureHierarchy()
        configureDataSource()
        configureDeleteItem()
    }
}

extension GridDeleteViewController {
    class MyCollectionViewCompositionalLayout: UICollectionViewCompositionalLayout {
        override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//            return super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
            let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
            print(attribute!)
            if attribute?.alpha == 0 {
                attribute?.alpha = 1.0
                attribute?.frame.origin.x -= self.collectionViewContentSize.width * 2
            }
            return attribute
        }
    }
    
    /// - Tag: Grid
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = MyCollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension GridDeleteViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<15))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDeleteItem() {
        let right = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDeleteEvent))
        navigationItem.rightBarButtonItem = right
    }
    
    @objc func onDeleteEvent() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(5..<15))
        dataSource.apply(snapshot, animatingDifferences: true)
//        var snapshot = dataSource.snapshot()
//        snapshot.deleteItems(Array(snapshot.itemIdentifiers[0..<5]))
//        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
