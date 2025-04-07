import Foundation

struct Row {
  var items: [Int]

  init(items: [Int]) {
    self.items = items
  }
}

var array = [
  Row(items: [1, 2]),
  Row(items: [3, 4]),
] {
  didSet {
    print("didset", array)
  }
}

array[0].items.remove(at: 0)

