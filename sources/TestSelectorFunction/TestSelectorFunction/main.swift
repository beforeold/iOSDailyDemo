import Foundation

extension NSObject {
  var myName: String {
    get {
      print("get", Selector(#function), #function)

      return ""
    }

    set {
      print("set", Selector(#function), #function)
    }
  }
}

let ins = NSObject()
ins.myName = "hello"
print(ins.myName)
