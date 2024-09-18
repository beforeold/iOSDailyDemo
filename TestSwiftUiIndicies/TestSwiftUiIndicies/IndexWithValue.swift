import Foundation

struct Item<Value> {
  var index: Int
  var value: Value
}

extension Array {
  var indiciesAndValues: [Item<Element>] {
    self.enumerated().map { index, value in
      Item(index: index, value: value)
    }
  }
}
