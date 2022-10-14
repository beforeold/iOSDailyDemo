//
//  RxDemoViewController.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import Foundation
import UIKit
import RxCocoa
import Combine

func intValue(_ string: String?) -> Int {
  let int = string?.last
    .flatMap(String.init)
    .flatMap(Int.init)
  return int ?? -1
}


class RxDemoViewController: UIViewController {
  
  @IBOutlet weak var inputField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    RxObservableType.test()
  }
  
  // https://boxueio.com/series/reactive-programming-in-swift/episode-documents/74
  func firstRx() {
    _ = inputField.rx.text
      .map(intValue)
      .filter { $0 % 2 == 0}
      .sink { value in
        print(value)
      }
  }
  
  
}

fileprivate func foo() {
  let publisher = PassthroughSubject<Int, Never>()
  _ = publisher.sink { value in
    print(value)
  }
}
