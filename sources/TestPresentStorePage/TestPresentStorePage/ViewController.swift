//
//  ViewController.swift
//  TestPresentStorePage
//
//  Created by Brook_Mobius on 5/17/23.
//

import UIKit
import StoreKit

class StorePresentor {
  let preparedVC: UIViewController
  
  init(appId: String) {
    let appId = "6446337794"
    let storeViewController = SKStoreProductViewController()
    preparedVC = storeViewController
    
    loadProduct()
  }
  
  private func loadProduct() {
    preparedVC.delegate = self
    let parameters = [ SKStoreProductParameterITunesItemIdentifier : appId ]
    preparedVC.loadProduct(withParameters: parameters, completionBlock: nil)
  }
  
  func present(fromSourceViewController sourceVC: UIViewController) {
    sourceVC.present(preparedVC, animated: true)
  }
}

class ViewController: UIViewController, SKStoreProductViewControllerDelegate {
  
  let
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appId = "6446337794"
    let storeViewController = SKStoreProductViewController()
    storeViewController.delegate = self
    let parameters = [ SKStoreProductParameterITunesItemIdentifier : appId ]
    storeViewController.loadProduct(withParameters: parameters, completionBlock: nil)
    
    storeVC = storeViewController
  }
  /// bubble: 6444612092
  /// pica: 6446337794
  func showAppStore(forAppId appId: String) {

    present(storeVC, animated: true, completion: nil)
  }
  
  func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
    print(#function)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    showAppStore(forAppId: "6446337794")
  }
}
