import Foundation

extension Array {
  func contains<V>(_ value: V, forKeyPath keyPath: KeyPath<Element, V>) -> Bool where V: Equatable {
    contains(
      where: { $0[keyPath: keyPath] == value }
    )
  }
}

struct Person {
  var name: String
}

do {
  let array = [Person(name: "Brook")]
  let ret = array.contains("Brook", forKeyPath: \.name)
  print(ret)
}

do {
  let array = [1, 2, 3]
  let ret = array.contains(5, forKeyPath: \.self)
  print(ret)
}
