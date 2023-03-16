//
//  ViewController.swift
//  TestInterview
//
//  Created by beforeold on 2023/2/21.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    test_reverseWords()
  }
  
  func test_reverseWords() {
    let ret = reverseWords(string: "hello world")
    print(ret)
  }
  
  func reverseWords(string: String) -> String {
    var string = ""
    string.append("bc")
    
    return ""
  }
  
  func subs(view: UIView) -> [UIView] {
    var ret: [UIView] = []
    var level: [UIView] = []
    
    level.append(view)
    
    while (level.count > 0) {
      // append level
      ret.append(contentsOf: level)
      
      // next level
      level = level.reduce(into: []) { partialResult, view in
        partialResult += view.subviews
      }
    }
    
    return ret
  }
}
