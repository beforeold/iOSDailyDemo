//
//  main.swift
//  DemoAsyncDefer
//
//  Created by beforeold on 2026/2/25.
//

import Foundation

print("Hello, World!")

func asyncFunc() async {
  defer {
    print("asyncFunc defer")
    await async2()
  }
  print("asyncFunc")
}

func async2() async {

}

