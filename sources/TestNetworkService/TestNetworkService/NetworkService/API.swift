//
//  API.swift
//  TestNetworkService
//
//  Created by Brook_Mobius on 8/9/23.
//

import Foundation

public struct API {
  public var path: String
  public var isGet: Bool
  public init(
    path: String,
    isGet: Bool
  ) {
    self.path = path
    self.isGet = isGet
  }
}
