//
//  ViewController.swift
//  TestRandom
//
//  Created by Brook_Mobius on 5/29/23.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let randomId = (0..<100).randomElement()!
    
    testRandom()
  }
  
  
  func testRandom() {
    var randomCounts: [Int] = [0, 0] // Counts for <50 and >=50
    let numberOfTrials = 1
    let numberOfCalls = 10_000
    
    for index in 1...numberOfTrials {
      randomCounts = [0, 0]
      for _ in 1...numberOfCalls {
        // [0, 100)
        let randomId = (0..<100).randomElement()!
        if randomId < 50 {
          randomCounts[0] += 1
        } else {
          randomCounts[1] += 1
        }
      }
//      print("Trial \(index): <50: \(randomCounts[0]), >=50: \(randomCounts[1]), diff: \(randomCounts[0] - randomCounts[1])")
    }
    
    // Calculate the percentages for <50 and >=50
    let totalCalls = numberOfTrials * numberOfCalls
    let percentageLessThan50 = Double(randomCounts[0]) / Double(totalCalls) * 100
    let percentageGreaterThanOrEqual50 = Double(randomCounts[1]) / Double(totalCalls) * 100
    
    print("Total Calls: \(totalCalls)")
    print("Percentage <50: \(percentageLessThan50)%")
    print("Percentage >=50: \(percentageGreaterThanOrEqual50)%")
  }
}

