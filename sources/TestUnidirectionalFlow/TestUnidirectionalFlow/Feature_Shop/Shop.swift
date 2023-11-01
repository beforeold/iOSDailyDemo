//
//  Feature_Shop.swift
//  TestUnidirectionalFlow
//
//  Created by Brook_Mobius on 11/1/23.
//

import Foundation

struct ShopState: Equatable {
  var products: [String] = []
}

enum ShopAction: Equatable {
  case add(String)
  case remove(String)
}

let reduce: (ShopState, ShopAction) -> ShopState = { state, action in
  var newState = state

  switch action {
  case let .add(product):
    newState.products.append(product)
  case let .remove(product):
    newState.products.removeAll { $0 == product }
  }

  return newState
}

typealias ShopStore = Store<ShopState, ShopAction>
