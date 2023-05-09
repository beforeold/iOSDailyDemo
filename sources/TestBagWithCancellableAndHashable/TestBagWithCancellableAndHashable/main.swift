//
//  main.swift
//  TestBagWithCancellableAndHashable
//
//  Created by Brook_Mobius on 5/9/23.
//

import Foundation
import Combine

extension Cancellable {
  public func store(in set: inout Set<AnyHashable>) {
    let any = AnyCancellable(self)
    let hash = AnyHashable(any)
    set.insert(hash)
  }
}

extension AnyCancellable {
  public func store(in set: inout Set<AnyHashable>) {
    let hash = AnyHashable(self)
    set.insert(hash)
  }
}

class Object {
  var bag: Set<AnyHashable> = .init()
  var bagCancel: Set<AnyCancellable> = .init()
  
  @Published var flag = false
  
  func foo() {
    $flag.sink { value in
      print("value", value)
    }
    .store(in: &bag)
    
    _ = bag.insert("b")
    print("contains b", bag.contains("b"))
  }
}


let ins = Object()
ins.foo()
