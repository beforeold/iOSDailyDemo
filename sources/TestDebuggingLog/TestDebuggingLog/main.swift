//
//  main.swift
//  TestDebuggingLog
//
//  Created by beforeold on 17/03/23.
//

import Foundation


public func debugging(_ closure: @autoclosure () -> Void) {
#if DEBUG
  _ = closure()
#endif
}


public func debugging2(_ closure: () -> Void) {
#if DEBUG
  _ = closure()
#endif
}

#if DEBUG
public func debugging3(_ closure: () -> Void) {

  _ = closure()
}
#else
public func debugging3(_ closure: () -> Void) {
}

#endif


debugging(print("okok"))

let name = "brook"

debugging2 {
  print("pkok2 \(name)")
}



func debugPrint(_ items: () -> Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, functionName: String = #function) {
  let ret = items.map { $0() }
  print(ret)
}
