import Foundation
import ObjectiveC

enum Some {
  case ok
}

let dictionary: [String: Any] = ["string": Optional<Int>.none as Any]

JSONPrinter.print(dictionary)

let value = dictionary["string"]
JSONPrinter.print(value)

// cast to object-c conversion
if let temp = value as? (any _ObjectiveCBridgeable) {
  print("converted", temp)
} else {
  print("is not objc")
}

do {
  let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
  let string = String(decoding: jsonData, as: UTF8.self)
  print("success", string)
} catch {
  print("failed", error)
}
