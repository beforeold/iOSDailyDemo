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
}
