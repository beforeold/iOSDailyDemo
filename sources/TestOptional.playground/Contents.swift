import UIKit

var greeting = "Hello"

/*
 @frozen public enum Optional<Wrapped> : ~Copyable where Wrapped : ~Copyable {

     /// The absence of a value.
     ///
     /// In code, the absence of a value is typically written using the `nil`
     /// literal rather than the explicit `.none` enumeration case.
     case none

     /// The presence of a value, stored as `Wrapped`.
     case some(Wrapped)
 */

do {
  let value1: Int? = 3
  let value2: Int? = 3
  let value3: Int? = .none
  let value4: Int? = .some(3)
}

struct Person {
  var name: String
}

do {
  let value: Person? = .init(name: "br")
  switch value {
  case nil:
    _ = "nil"
  case let person?:
    _ = "name: \(person.name)"
  }

  switch value {
  case .none:
    _ = "nil"
  case .some(let person):
    _ = "name: \(person.name)"
  }
}

public func compare<T>(optional: consuming T?, defaultValue: @autoclosure () throws -> T) rethrows -> T
where T: ~Copyable {
  if let optional {
    return optional
  }
  return try defaultValue()
}

do {
  let value: Int? = nil
  func get() -> Int {
    3
  }
  compare(optional: value, defaultValue: get())
}

extension Optional {
  var isNil: Bool { self == nil }
}

do {
  let array: [Int?]? = [1, 2]
  array?.filter(\.isNil)

  if (array?.count ?? 0) == 2 {

  }

  let flag: Bool? = false
  if flag == true {

  }

  print(flag ?? "no flag")
}
