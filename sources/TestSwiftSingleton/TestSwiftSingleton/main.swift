//
//  main.swift
//  TestSwiftSingleton
//
//  Created by Brook_Mobius on 4/28/23.
//

import Foundation

struct Object {
  static let shared: Object = .init()
  let id: String
  
  private init() {
    id = "abc"
  }
}

