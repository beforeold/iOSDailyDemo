//
//  Util.swift
//  TestCoreBlueTooth
//
//  Created by beforeold on 2022/10/12.
//

import Foundation

internal func info(of error: Error?) -> String {
  let info = (error as? NSError)?.userInfo ?? [:]
  let obj = info as NSDictionary
  return obj.description
}
