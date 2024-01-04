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

  func reload() {
    print("reload")
  }

  /// Task under main actor will also be called on main queue
  func bar() {
    //    DispatchQueue.global().async {
    print("task begin \(Thread.current)")

    for i in 0..<100 {
      Task {
        print("\(i)")
        self.reload()
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

func look() {
  Task {
    let controller = await ViewController()
    await controller.reload()
  }
}
