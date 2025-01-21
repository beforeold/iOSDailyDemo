import Foundation

class Object {
  let set: Set<AnyHashable> = []

  func contains(_ element: any Hashable) -> Bool {
    print(#function, #line)
    return set.contains(AnyHashable(element))
  }

  func contains<T>(_ element: T) -> Bool where T: Hashable {
    print(#function, #line)
    return set.contains(element)
  }
}

struct Value: Hashable {

}

let ins = Object()
print(ins.contains(5))
print(ins.contains(Value()))

