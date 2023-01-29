//
//  ItemsTableViewController.swift
//  CustomTransitions
//
//  Created by Joyce Echessa on 3/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
  
  let customPresentAnimationController = CustomPresentAnimationController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    
    cell.textLabel?.text = "Item 0\(indexPath.row + 1)"
    
    return cell
  }
}

extension ItemsTableViewController: UIViewControllerTransitioningDelegate {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAction" {
      let toViewController = segue.destination
      toViewController.transitioningDelegate = self
    }
  }
  
  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return customPresentAnimationController
  }
}
