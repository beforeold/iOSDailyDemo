import Foundation

class Object: NSObject {

}

let a = AnyHashable("123")

if let value = a as? String {
  print(value, "is string")
} else {
  print("value is not String")
}

let b = AnyHashable(Object())
if let obj = b as? Object {
  print(obj, "is Object")
} else {
  print("obj is not Object")
}
