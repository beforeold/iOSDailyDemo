//
//  ViewController.swift
//  TestIOS17
//
//  Created by Brook_Mobius on 6/15/23.
//

import UIKit
import Observation

@Observable
class Car {
  var name: String = ""
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    viewIsAppearing(true)
    
    let car = Car()
  }
  
  func testSensitiveContentAnalysis() {
    // import SensitiveContentAnalysis
  }

}
