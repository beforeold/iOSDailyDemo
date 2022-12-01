//
//  ViewController.swift
//  TestDiffableDataSource
//
//  Created by Brook_Mobius on 2022/12/1.
//

import UIKit

class ViewController: UIViewController {
  
  var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
  
  var count = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    let regis = UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, indexPath, itemIdentifier in
      
    }
    
    dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: regis, for: indexPath, item: itemIdentifier)
    }
    
    
    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
      self.refresh()
    }
    
    refresh()
  }
  
  func refresh() {
    count += 1
    
    var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    let sections = 0..<(200 + count)
    
    let begin = CFAbsoluteTimeGetCurrent()
    sections.forEach { section in
      snapshot.appendSections([section])
      let range = (section * 10)..<(section * 10 + 9)
      let items = range.map { $0 }
      snapshot.appendItems(items, toSection: section)
    }
    do {
      let end = CFAbsoluteTimeGetCurrent()
      print(1000 * (end - begin))
    }
    
    dataSource.apply(snapshot)
    
    do {
      let end = CFAbsoluteTimeGetCurrent()
      print(1000 * (end - begin))
    }
  }
}

