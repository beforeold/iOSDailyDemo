//
//  Delegate.swift
//  TestMethodAsClosure
//
//  Created by Brook_Mobius on 2023/3/31.
//

import Foundation

class WeakBox<T: AnyObject> {
  weak var value: T?
  
  init(_ value: T) {
    self.value = value
  }
}

class WeakWrapper<T: AnyObject> {
  private(set) weak var baseValue: T?
  
  init(_ baseValue: T) {
    self.baseValue = baseValue
  }
  
  func call(
    _ function: @escaping (T) -> () -> Void
  ) -> () -> Void {
    return { [weak baseValue] in
      guard let baseValue = baseValue else { return }
      return function(baseValue)()
    }
  }
}

func weakify<T: AnyObject, Arg>(
  _ baseValue: T,
  _ function: @escaping (T, Arg) -> Void
) -> (Arg) -> Void {
  return { [weak baseValue] arg in
    guard let baseValue = baseValue else { return }
    function(baseValue, arg)
  }
}

func weakify<T: AnyObject>(
  _ baseValue: T,
  _ function: @escaping (T) -> Void
) -> () -> Void {
  return { [weak baseValue] in
    guard let baseValue = baseValue else { return }
    function(baseValue)
  }
}


public class Delegate<Input, Output> {
    public init() {}

    private var block: ((Input) -> Output?)?
    public func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
        self.block = { [weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }

    public func call(_ input: Input) -> Output? {
        return block?(input)
    }

    public func callAsFunction(_ input: Input) -> Output? {
        return call(input)
    }
}
