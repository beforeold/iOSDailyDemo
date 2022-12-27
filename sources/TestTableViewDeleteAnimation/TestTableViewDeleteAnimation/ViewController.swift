//
//  ViewController.swift
//  TestTableViewDeleteAnimation
//
//  Created by Brook_Mobius on 2022/12/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

  var dataSource: UITableViewDiffableDataSource<Int, Int>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    let tableView = UITableView(frame: view.bounds, style: .plain)
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    
    dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = "\(itemIdentifier)"
      cell.contentView.backgroundColor = .lightGray
      
      return cell
    })
    dataSource.defaultRowAnimation = .left
    
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(Array(0..<10))
    dataSource.apply(snapshot, animatingDifferences: false)
    
    navigationItem.title = "TestTableViewDeleteAnimation"
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .trash, target: self, action: #selector(onDeleteEvent))
  }
  
  
  @objc func onDeleteEvent() {
    var snapshot = dataSource.snapshot()
    snapshot.deleteItems([snapshot.itemIdentifiers[0]])
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  
  
}

