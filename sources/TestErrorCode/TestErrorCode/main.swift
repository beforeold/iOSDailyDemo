//
//  main.swift
//  TestErrorCode
//
//  Created by Brook_Mobius on 10/9/23.
//

import Foundation

enum Failure: Error {
  case placeholder(Int)
  case other(Int)
}

do {
  let nsError = Failure.placeholder(5) as NSError
  let code = nsError.code
  let domain = nsError.domain
  let info = nsError.userInfo
  print(nsError, code, domain, info)
}

do {
  let nsError = Failure.other(5) as NSError
  let code = nsError.code
  let domain = nsError.domain
  let info = nsError.userInfo
  print(nsError, code, domain, info)
}
