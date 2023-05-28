//
//  ValueChanged.swift
//  TestValueChanged
//
//  Created by beforeold on 28/05/23.
//

import Combine

@propertyWrapper
public struct ValueChanged<T> {
  private var subject: CurrentValueSubject<T, Never>
  
  public init(wrappedValue: T) {
    subject = CurrentValueSubject(wrappedValue)
  }
  
  public var wrappedValue: T {
    get {
      return subject.value
    }
    
    nonmutating set {
      subject.value = newValue
    }
  }
  
  public var projectedValue: AnyPublisher<T, Never> {
    return subject.eraseToAnyPublisher()
  }
}
