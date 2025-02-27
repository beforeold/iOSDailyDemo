import Foundation

protocol P<T> {
  associatedtype T
  var type: T { get }
  mutating func setType(_ type: T)
}

struct C: P {
  var type: String = "Fuck Apple"

  mutating func setType(_ type: String) {
    self.type = type
    print("set type", type)
  }
}

func test() {
  var obj: any P<String> = C()
  //  var obj2 = obj
  let value = obj.type
  print("value", value)
  //  obj.type = "ok"
  obj.setType("ok")
  print(obj.type)
}

test()
