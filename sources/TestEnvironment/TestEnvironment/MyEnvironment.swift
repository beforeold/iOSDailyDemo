//
//  MyEnvironment.swift
//  TestEnvironment
//
//  Created by Brook_Mobius on 11/9/23.
//

import SwiftUI

//public protocol MyEnvironmentKey {
//  associatedtype Value
//  static var defaultValue: Self.Value { get }
//}
//
//public struct EnvironmentValues: CustomStringConvertible {
//  var values: [ObjectIdentifier: Any] = [:]
//
//  public init() {
//  }
//
//  public subscript<K>(key: K.Type) -> K.Value where K: MyEnvironmentKey {
//    get {
//      if let value = values[ObjectIdentifier(key)] as? K.Value {
//        return value
//      }
//      return K.defaultValue
//    }
//    set {
//      values[ObjectIdentifier(key)] = newValue
//    }
//  }
//  public var description: String {
//    get {
//      return ""
//    }
//  }
//}

//protocol DynamicProperty {
//
//}

@propertyWrapper public struct MyEnvironment<Value>: DynamicProperty {
  internal enum Content {
    case keyPath(KeyPath<EnvironmentValues, Value>)
    case value(Value)
  }

  internal var content: MyEnvironment<Value>.Content

  public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
    content = .keyPath(keyPath)
  }

  public var wrappedValue: Value {
    get {
      switch content {
      case let .value(value):
        return value
      case let .keyPath(keyPath):
        // not bound to a view, return the default value.
        return EnvironmentValues()[keyPath: keyPath]
      }
    }
  }

  internal func error() -> Never {
    fatalError()
  }
}

public struct _EnvironmentKeyWritingModifier<Value>: ViewModifier {
  public var keyPath: WritableKeyPath<EnvironmentValues, Value>
  public var value: Value
  public init(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
    self.keyPath = keyPath
    self.value = value
  }
  public typealias Body = Never
}

extension View {
  public func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> some View {
    return modifier(_EnvironmentKeyWritingModifier(keyPath: keyPath, value: value))
  }

  public func environment<V>(_ value: V) -> some View where T: Observable, T: AnyObject {
    return modifier(_EnvironmentKeyWritingModifier(val: value))
  }
}
