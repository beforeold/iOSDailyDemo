//
//  main.swift
//  TestAnyHashableOrderedsET
//
//  Created by Brook_Mobius on 2022/11/29.
//

import Foundation
import Collections

/// a wrapper for the idenrtifiable type, same id will be treated as same instance
public struct AnyIDHashable<ID: Hashable>: Hashable {
  private let value: Any
  private let id: ID
  
  /// create a box with a initial value
  public init<Value: Identifiable>(value: Value) where Value.ID == ID {
    self.value = value
    self.id = value.id
  }
  
  /// get the value with initial type
  public func getValue<Value>(as type: Value.Type) -> Value {
    return value as! Value
  }
  
  public static func == (lhs: AnyIDHashable<ID>, rhs: AnyIDHashable<ID>) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Identifiable {
  var boxedWithId: AnyIDHashable<ID> {
    return AnyIDHashable<ID>(value: self)
  }
}

fileprivate func foo() {
  struct Value111: Hashable, Identifiable {
    var id: String
  }
  
  struct Item222: Hashable, Identifiable {
    var id: String
  }
  
  var set: Set<AnyIDHashable<String>> = .init()
  set.insert(Value111(id: "5").boxedWithId)
  set.remove(Item222(id: "5").boxedWithId)
  print("set:", set)
  
  let box = Value111(id: "555").boxedWithId
  let value = box.getValue(as: Value111.self)
  print("id:", value.id)
}


foo()

