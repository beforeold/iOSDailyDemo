//
//  ViewController.swift
//  TestValueChanged
//
//  Created by beforeold on 28/05/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

  @ValueChanged var age: Int = 5
  
  var bag: Set<AnyCancellable> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    print(#function, "age", age)
    
    
    let label = UILabel(frame: .init(x: 100, y: 100, width: 100, height: 100))
    view.addSubview(label)
    
    $age
      .map(toString)
      .assign(to: \.text, on: label)
      .store(in: &bag)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    age += 7
  }
  
  
}

