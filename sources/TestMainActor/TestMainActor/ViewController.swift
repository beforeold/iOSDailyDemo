//
//  ViewController.swift
//  TestMainActor
//
//  Created by Brook_Mobius on 1/3/24.
//

import UIKit

// @MainActor
func foo() {
//  print("foo \(Thread.current)")
  print(#function)
}

func buzz() {
//  print("foo \(Thread.current)")
  print(#function)
}

func asyncFunc() async {
  print(#function)
}

func callIntTask(block: @escaping () -> Void) {
  Task {
    block()
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    bar()
  }

  func fizz() {
    callIntTask {
      print("fizz")
    }
  }

  func bar() {
    //    DispatchQueue.global().async {
    print("task begin \(Thread.current)")

    for i in 0..<100 {
      Task {
        print("\(i)")
      }
    }

    Task {

      buzz()
      foo()

      await asyncFunc()

      buzz()
    }
    print("task end \(Thread.current)")
    //    }
  }
}

